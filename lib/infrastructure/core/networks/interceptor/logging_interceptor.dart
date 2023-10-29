import 'dart:async';

import 'package:dio/dio.dart';
import 'package:kopianan_boilerplate/core/log.dart';
import 'package:kopianan_boilerplate/injection.dart';

class LoggingInterceptor extends Interceptor {
  Log get log => getIt<Log>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();

    buffer.writeln('HTTP REQUEST');
    buffer.writeln('==============================');

    buffer.writeln(
      '${options.method.toUpperCase()} ${(options.baseUrl) + options.path}',
    );

    buffer.writeln('Headers:');
    options.headers.forEach(
      (k, v) => buffer.writeln('$k: $v'),
    );

    buffer.writeln('Query Parameters:');
    options.queryParameters.forEach(
      (k, v) => buffer.writeln('$k: $v'),
    );

    if (options.data != null) {
      buffer.writeln('Body: ${options.data}');
    }

    log.console(buffer.toString());

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    final buffer = StringBuffer();

    buffer.writeln('HTTP RESPONSE');
    buffer.writeln('==============================');

    buffer.writeln(
      '${response.statusCode} (${response.statusMessage})'
      '${response.requestOptions.baseUrl + response.requestOptions.path}',
    );

    buffer.writeln('Headers:');
    response.headers.forEach(
      (k, v) => buffer.writeln('$k: $v'),
    );

    buffer.writeln('Body: ${response.data}');
    log.console(buffer.toString());

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final buffer = StringBuffer();

    buffer.writeln(
      'HTTP ERROR',
    );
    buffer.writeln(
      '==============================',
    );

    var request = err.requestOptions;

    if (err.response != null) {
      var response = err.response!;
      buffer.writeln(
        '${err.response!.statusCode} (${err.response!.statusMessage})'
        '${request.baseUrl}${request.path}',
      );

      buffer.writeln('Body: ${response.data}');
    } else {
      buffer.writeln(
        '${err.error} (${err.type})'
        '${request.baseUrl}${request.path}',
      );
    }
    log.console(buffer.toString(), type: LogType.error);

    return super.onError(err, handler);
  }
}
