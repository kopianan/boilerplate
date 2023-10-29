import 'package:dio/dio.dart';

class HttpSetting {
  final bool useHttp2;
  final String baseUrl;
  final String contentType;
  final HttpTimeout timeout;
  final List<Interceptor>? interceptors;

  HttpSetting({
    required this.baseUrl,
    this.interceptors,
    this.useHttp2 = false,
    this.contentType = 'application/json',
    this.timeout = const HttpTimeout(),
  });
}

class HttpTimeout {
  /// Timeout for client to receive connection from server. [In milliseconds]
  ///
  /// Time between client start the connection to server and
  /// the server give the first handshake to the client.
  final int connectTimeout;

  /// Timeout for client to send data to server. [In milliseconds]
  ///
  /// Time between client to start sending request data
  /// until it finishes.
  final int sendTimeout;

  /// Timeout for client to receive data from server. [In milliseconds]
  ///
  /// Time between client has connected to the server,
  /// and the server has finish to send data to the client.
  final int receiveTimeout;

  const HttpTimeout({
    this.connectTimeout = 30000,
    this.sendTimeout = 10000,
    this.receiveTimeout = 10000,
  });
}
