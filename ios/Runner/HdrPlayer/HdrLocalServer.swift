import Foundation
import Network

/// Minimal HTTP/1.1 file server bound to 127.0.0.1 on an ephemeral port.
/// Serves the bridge's playlist directory to AVPlayer with correct HLS MIME
/// types and byte-range support — the transports AVFoundation actually
/// accepts for HLS are plain http(s); file:// playlists and resource-loader
/// media segments are rejected by mediaserverd.
final class HdrLocalServer {
    private let root: URL
    private var listener: NWListener?
    private let queue = DispatchQueue(label: "piliplus.hdr.httpd")
    private(set) var port: UInt16 = 0

    init(root: URL) {
        self.root = root
    }

    func start() throws {
        let params = NWParameters.tcp
        params.requiredLocalEndpoint = NWEndpoint.hostPort(host: "127.0.0.1", port: .any)
        let listener = try NWListener(using: params)
        self.listener = listener
        let ready = DispatchSemaphore(value: 0)
        listener.stateUpdateHandler = { [weak self] state in
            if case .ready = state {
                self?.port = listener.port?.rawValue ?? 0
                ready.signal()
            }
            if case .failed = state {
                ready.signal()
            }
        }
        listener.newConnectionHandler = { [weak self] connection in
            self?.serve(connection)
        }
        listener.start(queue: queue)
        _ = ready.wait(timeout: .now() + 3)
        guard port != 0 else {
            throw DashHlsError.parse("local http server failed to bind")
        }
    }

    func stop() {
        listener?.cancel()
        listener = nil
    }

    var baseUrl: URL { URL(string: "http://127.0.0.1:\(port)/")! }

    // MARK: - Connection handling

    private func serve(_ connection: NWConnection) {
        connection.start(queue: queue)
        readRequest(connection, buffer: Data())
    }

    private func readRequest(_ connection: NWConnection, buffer: Data) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 16384) {
            [weak self] data, _, isComplete, error in
            guard let self, error == nil else {
                connection.cancel()
                return
            }
            var buffer = buffer
            if let data { buffer.append(data) }
            if let headerEnd = buffer.range(of: Data("\r\n\r\n".utf8)) {
                let head = String(data: buffer[..<headerEnd.lowerBound], encoding: .utf8) ?? ""
                self.respond(connection, head: head)
            } else if isComplete || buffer.count > 65536 {
                connection.cancel()
            } else {
                self.readRequest(connection, buffer: buffer)
            }
        }
    }

    private func respond(_ connection: NWConnection, head: String) {
        let lines = head.components(separatedBy: "\r\n")
        let request = lines.first?.components(separatedBy: " ") ?? []
        guard request.count >= 2 else {
            send(connection, status: "400 Bad Request", body: Data(), type: "text/plain")
            return
        }
        let method = request[0]
        let rawPath = request[1].components(separatedBy: "?").first ?? "/"
        let name = (rawPath as NSString).lastPathComponent
        let fileUrl = root.appendingPathComponent(name)

        guard method == "GET" || method == "HEAD",
              !name.isEmpty,
              !name.contains(".."),
              let handle = try? FileHandle(forReadingFrom: fileUrl)
        else {
            send(connection, status: "404 Not Found", body: Data(), type: "text/plain")
            return
        }
        defer { try? handle.close() }
        let total = Int64(handle.seekToEndOfFile())

        var rangeStart: Int64 = 0
        var rangeEnd: Int64 = total - 1
        var isPartial = false
        for line in lines.dropFirst() {
            let lower = line.lowercased()
            guard lower.hasPrefix("range:") else { continue }
            let spec = line.dropFirst(6).trimmingCharacters(in: .whitespaces)
            guard spec.lowercased().hasPrefix("bytes=") else { continue }
            let parts = spec.dropFirst(6).components(separatedBy: "-")
            if parts.count == 2 {
                if let s = Int64(parts[0]) { rangeStart = s }
                if let e = Int64(parts[1]), !parts[1].isEmpty { rangeEnd = e }
                isPartial = true
            }
        }
        rangeEnd = min(rangeEnd, total - 1)
        guard rangeStart <= rangeEnd else {
            send(connection, status: "416 Range Not Satisfiable", body: Data(), type: "text/plain")
            return
        }

        let type: String
        switch (name as NSString).pathExtension.lowercased() {
        case "m3u8": type = "application/vnd.apple.mpegurl"
        case "m4s", "mp4": type = "video/mp4"
        default: type = "application/octet-stream"
        }

        var body = Data()
        if method == "GET" {
            handle.seek(toFileOffset: UInt64(rangeStart))
            body = handle.readData(ofLength: Int(rangeEnd - rangeStart + 1))
        }

        var header = isPartial ? "HTTP/1.1 206 Partial Content\r\n" : "HTTP/1.1 200 OK\r\n"
        header += "Content-Type: \(type)\r\n"
        header += "Accept-Ranges: bytes\r\n"
        header += "Content-Length: \(rangeEnd - rangeStart + 1)\r\n"
        if isPartial {
            header += "Content-Range: bytes \(rangeStart)-\(rangeEnd)/\(total)\r\n"
        }
        header += "Connection: close\r\n\r\n"

        var payload = Data(header.utf8)
        payload.append(body)
        connection.send(content: payload, completion: .contentProcessed { _ in
            connection.cancel()
        })
    }

    private func send(_ connection: NWConnection, status: String, body: Data, type: String) {
        var header = "HTTP/1.1 \(status)\r\n"
        header += "Content-Type: \(type)\r\nContent-Length: \(body.count)\r\nConnection: close\r\n\r\n"
        var payload = Data(header.utf8)
        payload.append(body)
        connection.send(content: payload, completion: .contentProcessed { _ in
            connection.cancel()
        })
    }
}
