import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:PiliPlus/utils/storage_pref.dart';

final class AppDns {
  AppDns._();

  static final _random = Random.secure();
  static final _cache = <String, _CacheEntry>{};
  static const _dnsPort = 53;
  static const _dnsTimeout = Duration(seconds: 2);
  static const _cacheMinTtl = 30;
  static const _cacheMaxTtl = 600;
  static const _typeA = 1;
  static const _typeAaaa = 28;

  static void clearCache() => _cache.clear();

  static List<_DnsServer> get _servers {
    final customServers = Pref.appDnsServers
        .split(RegExp(r'[\s,，;；]+'))
        .map(_parseServer)
        .nonNulls
        .toList();
    return customServers.isEmpty ? _defaultServers : customServers;
  }

  static String get defaultServersText =>
      _defaultServers.map((item) => item.toString()).join('\n');

  static String normalizeServersText(String value) => value
      .split(RegExp(r'[\s,，;；]+'))
      .map(_parseServer)
      .nonNulls
      .map((item) => item.toString())
      .join('\n');

  static bool isValidServersText(String value) {
    final values = value.split(RegExp(r'[\s,，;；]+')).where((e) => e.isNotEmpty);
    return values.every((item) => _parseServer(item) != null);
  }

  static final _defaultServers = [
    _DnsServer(InternetAddress('223.5.5.5', type: InternetAddressType.IPv4)),
    _DnsServer(InternetAddress('119.29.29.29', type: InternetAddressType.IPv4)),
    _DnsServer(InternetAddress('1.1.1.1', type: InternetAddressType.IPv4)),
    _DnsServer(InternetAddress('8.8.8.8', type: InternetAddressType.IPv4)),
  ];

  static Future<List<InternetAddress>> lookup(
    String host, {
    InternetAddressType type = InternetAddressType.any,
  }) async {
    final address = InternetAddress.tryParse(host);
    if (address != null) {
      return _matchesType(address, type) ? [address] : const [];
    }
    if (host == 'localhost') {
      return switch (type) {
        InternetAddressType.IPv4 => [InternetAddress.loopbackIPv4],
        InternetAddressType.IPv6 => [InternetAddress.loopbackIPv6],
        _ => [InternetAddress.loopbackIPv4, InternetAddress.loopbackIPv6],
      };
    }

    final normalizedHost = host.endsWith('.')
        ? host.substring(0, host.length - 1)
        : host;
    final cacheKey = '$normalizedHost:${type.name}';
    final cached = _cache[cacheKey];
    if (cached != null && cached.expiresAt.isAfter(DateTime.now())) {
      return cached.addresses;
    }

    final dnsAddresses = switch (type) {
      InternetAddressType.IPv4 => await _query(normalizedHost, _typeA),
      InternetAddressType.IPv6 => await _query(normalizedHost, _typeAaaa),
      _ => [
        ...await _query(normalizedHost, _typeA),
        ...await _query(normalizedHost, _typeAaaa),
      ],
    };
    final addresses = _deduplicate(dnsAddresses);

    if (addresses.isEmpty) {
      throw SocketException('App DNS lookup failed: $host');
    }
    _cache[cacheKey] = _CacheEntry(addresses, _ttlDuration(dnsAddresses));
    return addresses;
  }

  static Future<Socket> connect(
    String host,
    int port, {
    Duration? timeout,
  }) async {
    final addresses = await lookup(host);
    Object? lastError;
    StackTrace? lastStackTrace;
    for (final address in addresses) {
      try {
        return await Socket.connect(address, port, timeout: timeout);
      } catch (e, stackTrace) {
        lastError = e;
        lastStackTrace = stackTrace;
      }
    }
    Error.throwWithStackTrace(
      SocketException(
        'App DNS resolved $host but failed to connect to $host:$port: '
        '$lastError',
      ),
      lastStackTrace ?? StackTrace.current,
    );
  }

  static Future<ConnectionTask<Socket>> connectionTask(
    Uri uri,
    String? proxyHost,
    int? proxyPort, {
    SecurityContext? context,
    required bool acceptBadCertificate,
  }) {
    final host = proxyHost ?? uri.host;
    final port = proxyPort ?? uri.port;
    final socketFuture = proxyHost != null || !uri.isScheme('https')
        ? connect(host, port)
        : connect(host, port).then<Socket>(
            (socket) => SecureSocket.secure(
              socket,
              host: uri.host,
              context: context,
              onBadCertificate: acceptBadCertificate ? (_) => true : null,
            ),
          );
    return Future.value(ConnectionTask.fromSocket(socketFuture, () {}));
  }

  static Future<List<_DnsAddress>> _query(String host, int type) async {
    final completer = Completer<List<_DnsAddress>>();
    final dnsServers = _servers;
    var pending = dnsServers.length;

    void completeEmpty() {
      pending--;
      if (pending == 0 && !completer.isCompleted) {
        completer.complete(const []);
      }
    }

    for (final server in dnsServers) {
      unawaited(
        _queryServer(server, host, type).then<void>((response) {
          if (response.isEmpty) {
            completeEmpty();
          } else if (!completer.isCompleted) {
            completer.complete(response);
          }
        }, onError: (_) => completeEmpty()),
      );
    }

    final result = await completer.future.timeout(
      _dnsTimeout,
      onTimeout: () => const [],
    );
    return result;
  }

  static Future<List<_DnsAddress>> _queryServer(
    _DnsServer server,
    String host,
    int type,
  ) async {
    RawDatagramSocket? socket;
    try {
      final id = _random.nextInt(0x10000);
      final query = _buildQuery(id, host, type);
      final dnsSocket = socket = await RawDatagramSocket.bind(
        server.bindAddress,
        0,
      );
      // ignore: cascade_invocations
      dnsSocket.send(query, server.address, server.port);

      final completer = Completer<List<_DnsAddress>>();
      late final StreamSubscription subscription;
      subscription = dnsSocket.listen((event) {
        if (event != RawSocketEvent.read) return;
        final datagram = dnsSocket.receive();
        if (datagram == null) return;
        final response = _parseResponse(datagram.data, id, type);
        if (response != null && !completer.isCompleted) {
          completer.complete(response);
        }
      });

      return await completer.future
          .timeout(_dnsTimeout, onTimeout: () => const [])
          .whenComplete(subscription.cancel);
    } finally {
      socket?.close();
    }
  }

  static Uint8List _buildQuery(int id, String host, int type) {
    final bytes = BytesBuilder(copy: false);

    void addUint16(int value) {
      bytes.add([(value >> 8) & 0xff, value & 0xff]);
    }

    addUint16(id);
    addUint16(0x0100);
    addUint16(1);
    addUint16(0);
    addUint16(0);
    addUint16(0);

    for (final label in host.split('.')) {
      final labelBytes = ascii.encode(label);
      if (labelBytes.isEmpty || labelBytes.length > 63) {
        throw SocketException('Invalid DNS label: $host');
      }
      bytes
        ..add([labelBytes.length])
        ..add(labelBytes);
    }
    bytes.addByte(0);
    addUint16(type);
    addUint16(1);
    return bytes.toBytes();
  }

  static List<_DnsAddress>? _parseResponse(
    Uint8List data,
    int id,
    int queryType,
  ) {
    if (data.length < 12 || _readUint16(data, 0) != id) return null;
    if ((_readUint16(data, 2) & 0x000f) != 0) return const [];

    final questionCount = _readUint16(data, 4);
    final answerCount = _readUint16(data, 6);
    var offset = 12;

    for (var i = 0; i < questionCount; i++) {
      offset = _skipName(data, offset) + 4;
      if (offset > data.length) return const [];
    }

    final addresses = <_DnsAddress>[];
    for (var i = 0; i < answerCount; i++) {
      offset = _skipName(data, offset);
      if (offset + 10 > data.length) return addresses;
      final type = _readUint16(data, offset);
      final dnsClass = _readUint16(data, offset + 2);
      final ttl = _readUint32(data, offset + 4);
      final length = _readUint16(data, offset + 8);
      offset += 10;
      if (offset + length > data.length) return addresses;

      final isA = type == _typeA && length == 4;
      final isAaaa = type == _typeAaaa && length == 16;
      if (dnsClass == 1 && type == queryType && (isA || isAaaa)) {
        addresses.add(
          _DnsAddress(
            InternetAddress.fromRawAddress(
              Uint8List.fromList(data.sublist(offset, offset + length)),
              type: isA ? InternetAddressType.IPv4 : InternetAddressType.IPv6,
            ),
            ttl.clamp(_cacheMinTtl, _cacheMaxTtl).toInt(),
          ),
        );
      }
      offset += length;
    }
    return addresses;
  }

  static int _skipName(Uint8List data, int offset) {
    while (offset < data.length) {
      final length = data[offset];
      if (length == 0) return offset + 1;
      if ((length & 0xc0) == 0xc0) return offset + 2;
      offset += length + 1;
    }
    return data.length + 1;
  }

  static int _readUint16(Uint8List data, int offset) =>
      (data[offset] << 8) | data[offset + 1];

  static int _readUint32(Uint8List data, int offset) =>
      (data[offset] << 24) |
      (data[offset + 1] << 16) |
      (data[offset + 2] << 8) |
      data[offset + 3];

  static bool _matchesType(InternetAddress address, InternetAddressType type) =>
      type == InternetAddressType.any || address.type == type;

  static List<InternetAddress> _deduplicate(List<_DnsAddress> addresses) {
    final seen = <String>{};
    return [
      for (final item in addresses)
        if (seen.add(item.address.address)) item.address,
    ];
  }

  static Duration _ttlDuration(List<_DnsAddress> addresses) {
    final ttl = addresses.fold<int>(
      _cacheMaxTtl,
      (value, address) => min(value, address.ttl),
    );
    return Duration(seconds: ttl.clamp(_cacheMinTtl, _cacheMaxTtl).toInt());
  }

  static _DnsServer? _parseServer(String value) {
    if (value.isEmpty) return null;
    final (host, port) = _splitHostPort(value);
    if (port < 1 || port > 65535) return null;
    final address = InternetAddress.tryParse(host);
    if (address == null) return null;
    return _DnsServer(address, port);
  }

  static (String, int) _splitHostPort(String value) {
    if (value.startsWith('[')) {
      final end = value.indexOf(']');
      if (end > 0) {
        final host = value.substring(1, end);
        final port = value.length > end + 2 && value[end + 1] == ':'
            ? int.tryParse(value.substring(end + 2)) ?? _dnsPort
            : _dnsPort;
        return (host, port);
      }
    }

    final colonIndex = value.lastIndexOf(':');
    if (colonIndex > 0 && value.indexOf(':') == colonIndex) {
      final port = int.tryParse(value.substring(colonIndex + 1));
      if (port != null) {
        return (value.substring(0, colonIndex), port);
      }
    }
    return (value, _dnsPort);
  }
}

final class _DnsServer {
  const _DnsServer(this.address, [this.port = AppDns._dnsPort]);

  final InternetAddress address;
  final int port;

  InternetAddress get bindAddress => switch (address.type) {
    InternetAddressType.IPv6 => InternetAddress.anyIPv6,
    _ => InternetAddress.anyIPv4,
  };

  @override
  String toString() {
    if (port == AppDns._dnsPort) {
      return address.address;
    }
    if (address.type == InternetAddressType.IPv6) {
      return '[${address.address}]:$port';
    }
    return '${address.address}:$port';
  }
}

final class _DnsAddress {
  const _DnsAddress(this.address, this.ttl);

  final InternetAddress address;
  final int ttl;
}

final class _CacheEntry {
  _CacheEntry(List<InternetAddress> addresses, Duration ttl)
    : addresses = List.unmodifiable(addresses),
      expiresAt = DateTime.now().add(ttl);

  final List<InternetAddress> addresses;
  final DateTime expiresAt;
}
