import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/http/app_dns.dart';
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:http2/http2.dart';

final class AppDnsConnectionManager implements ConnectionManager {
  AppDnsConnectionManager({
    Duration? idleTimeout,
    Duration? handshakeTimeout,
    this.onClientCreate,
    this.proxyConnectedPredicate = defaultProxyConnectedPredicate,
  }) : _idleTimeout = idleTimeout ?? const Duration(seconds: 1),
       _handshakeTimeout = handshakeTimeout ?? const Duration(seconds: 15);

  final void Function(Uri uri, ClientSetting setting)? onClientCreate;
  final ProxyConnectedPredicate proxyConnectedPredicate;
  final Duration _idleTimeout;
  final Duration _handshakeTimeout;
  final _transportsMap = <String, _ClientTransportConnectionState>{};
  final _connectFutures = <String, Future<_ClientTransportConnectionState>>{};

  bool _closed = false;
  bool _forceClosed = false;

  @override
  int get cachedConnectionsCount => _transportsMap.length;

  String _getCacheKey(Uri uri) => '${uri.scheme}://${uri.host}:${uri.port}';

  @override
  Future<ClientTransportConnection> getConnection(
    RequestOptions options,
    List<RedirectRecord> redirects,
  ) async {
    if (_closed) {
      throw Exception(
        "Can't establish connection after [ConnectionManager] closed!",
      );
    }
    var uri = options.uri;
    if (redirects.isNotEmpty) {
      uri = Http2Adapter.resolveRedirectUri(uri, redirects.last.location);
    }
    final transportCacheKey = _getCacheKey(uri);
    var transportState = _transportsMap[transportCacheKey];
    if (transportState == null) {
      var initFuture = _connectFutures[transportCacheKey];
      if (initFuture == null) {
        _connectFutures[transportCacheKey] = initFuture = _connect(
          options,
          redirects,
        );
      }
      try {
        transportState = await initFuture;
      } catch (_) {
        _connectFutures.remove(transportCacheKey);
        rethrow;
      }
      if (_forceClosed) {
        transportState.dispose();
      } else {
        _transportsMap[transportCacheKey] = transportState;
        _connectFutures.remove(transportCacheKey);
      }
    } else if (!transportState.transport.isOpen) {
      transportState.dispose();
      _transportsMap[transportCacheKey] = transportState = await _connect(
        options,
        redirects,
      );
    }
    return transportState.activeTransport;
  }

  Future<_ClientTransportConnectionState> _connect(
    RequestOptions options,
    List<RedirectRecord> redirects,
  ) async {
    var uri = options.uri;
    if (redirects.isNotEmpty) {
      uri = Http2Adapter.resolveRedirectUri(uri, redirects.last.location);
    }
    final domain = _getCacheKey(uri);
    final clientConfig = ClientSetting();
    onClientCreate?.call(uri, clientConfig);

    late final Socket socket;
    try {
      socket = await _createSocket(uri, options, clientConfig);
    } on SocketException catch (e) {
      if (e.osError == null && e.message.contains('timed out')) {
        throw DioException.connectionTimeout(
          timeout: options.connectTimeout ?? Duration.zero,
          requestOptions: options,
        );
      }
      rethrow;
    }

    if (clientConfig.validateCertificate != null) {
      final certificate = socket is SecureSocket
          ? socket.peerCertificate
          : null;
      final isCertApproved = clientConfig.validateCertificate!(
        certificate,
        uri.host,
        uri.port,
      );
      if (!isCertApproved) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.badCertificate,
          error: certificate,
          message: 'The certificate of the response is not approved.',
        );
      }
    }

    final transport = ClientTransportConnection.viaSocket(socket);
    final transportState = _ClientTransportConnectionState(transport);
    transport.onActiveStateChanged = (isActive) {
      transportState.isActive = isActive;
      if (!isActive) {
        transportState.latestIdleTimeStamp = DateTime.now();
      }
    };

    transportState.delayClose(
      _closed ? const Duration(milliseconds: 50) : _idleTimeout,
      () {
        _transportsMap.remove(domain);
        transportState.transport.finish();
      },
    );
    return transportState;
  }

  Future<Socket> _createSocket(
    Uri target,
    RequestOptions options,
    ClientSetting clientConfig,
  ) async {
    final timeout = (options.connectTimeout ?? Duration.zero) > Duration.zero
        ? options.connectTimeout!
        : null;
    final proxy = clientConfig.proxy;

    if (proxy == null) {
      if (target.scheme != 'https') {
        return AppDns.connect(target.host, target.port, timeout: timeout);
      }
      final socket = await AppDns.connect(
        target.host,
        target.port,
        timeout: timeout,
      );
      final secureSocket = await SecureSocket.secure(
        socket,
        host: target.host,
        context: clientConfig.context,
        onBadCertificate: clientConfig.onBadCertificate,
        supportedProtocols: ['h2'],
      ).timeout(_handshakeTimeout);
      _throwIfH2NotSelected(target, secureSocket);
      return secureSocket;
    }

    final proxySocket = await AppDns.connect(
      proxy.host,
      proxy.port,
      timeout: timeout,
    );

    final credentialsProxy = base64Encode(utf8.encode(proxy.userInfo));

    const crlf = '\r\n';
    const proxyProtocol = 'HTTP/1.1';
    proxySocket
      ..write('CONNECT ${target.host}:${target.port} $proxyProtocol')
      ..write(crlf)
      ..write('Host: ${target.host}:${target.port}');
    if (credentialsProxy.isNotEmpty) {
      proxySocket
        ..write(crlf)
        ..write('Proxy-Authorization: Basic $credentialsProxy');
    }
    proxySocket
      ..write(crlf)
      ..write(crlf);

    final completerProxyInitialization = Completer<void>();

    Never onProxyError(Object? error, StackTrace stackTrace) {
      throw DioException(
        requestOptions: options,
        error: error,
        type: DioExceptionType.connectionError,
        stackTrace: stackTrace,
      );
    }

    completerProxyInitialization.future.onError(onProxyError);

    final proxySubscription = proxySocket.listen(
      (event) {
        final response = ascii.decode(event, allowInvalid: true);
        final statusLine = response.split(crlf).first;
        if (!completerProxyInitialization.isCompleted) {
          if (proxyConnectedPredicate(proxyProtocol, statusLine)) {
            completerProxyInitialization.complete();
          } else {
            completerProxyInitialization.completeError(
              SocketException(
                'Proxy cannot be initialized with status = [$statusLine], '
                'host = ${target.host}, port = ${target.port}',
              ),
            );
          }
        }
      },
      onError: (e, s) {
        if (!completerProxyInitialization.isCompleted) {
          completerProxyInitialization.completeError(e, s);
        }
      },
    );

    await completerProxyInitialization.future;

    final socket = await SecureSocket.secure(
      proxySocket,
      host: target.host,
      context: clientConfig.context,
      onBadCertificate: clientConfig.onBadCertificate,
      supportedProtocols: ['h2'],
    ).timeout(_handshakeTimeout);
    _throwIfH2NotSelected(target, socket);

    proxySubscription.cancel();
    return socket;
  }

  @override
  void removeConnection(ClientTransportConnection transport) {
    _ClientTransportConnectionState? transportState;
    _transportsMap.removeWhere((_, state) {
      if (state.transport == transport) {
        transportState = state;
        return true;
      }
      return false;
    });
    transportState?.dispose();
  }

  @override
  void close({bool force = false}) {
    _closed = true;
    _forceClosed = force;
    if (force) {
      for (final state in _transportsMap.values) {
        state.dispose();
      }
      _transportsMap.clear();
    }
  }

  void _throwIfH2NotSelected(Uri target, SecureSocket socket) {
    if (socket.selectedProtocol != 'h2') {
      throw DioH2NotSupportedException(target, socket.selectedProtocol);
    }
  }
}

final class _ClientTransportConnectionState {
  _ClientTransportConnectionState(this.transport);

  final ClientTransportConnection transport;
  bool isActive = true;
  late DateTime latestIdleTimeStamp;
  Timer? _timer;

  ClientTransportConnection get activeTransport {
    isActive = true;
    latestIdleTimeStamp = DateTime.now();
    return transport;
  }

  void delayClose(Duration idleTimeout, void Function() callback) {
    const duration = Duration(milliseconds: 100);
    idleTimeout = idleTimeout < duration ? duration : idleTimeout;
    _startTimer(callback, idleTimeout, idleTimeout);
  }

  void dispose() {
    _timer?.cancel();
    transport.finish();
  }

  void _startTimer(
    void Function() callback,
    Duration duration,
    Duration idleTimeout,
  ) {
    _timer = Timer(duration, () {
      if (!isActive) {
        final idleDuration = DateTime.now().difference(latestIdleTimeStamp);
        if (idleDuration >= duration) {
          return callback();
        }
        return _startTimer(callback, duration - idleDuration, idleTimeout);
      }
      _startTimer(callback, idleTimeout, idleTimeout);
    });
  }
}
