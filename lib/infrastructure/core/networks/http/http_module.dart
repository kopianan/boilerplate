import 'dart:convert';
import 'dart:io' as io;

import 'dart:developer' as dev;
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';

import 'package:kopianan_boilerplate/core/error/exceptions.dart';
import 'package:kopianan_boilerplate/core/log.dart';
import 'package:kopianan_boilerplate/infrastructure/core/networks/api_exception.dart';
import 'package:kopianan_boilerplate/infrastructure/core/networks/http/http_client.dart';
import 'package:kopianan_boilerplate/injection.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class HttpModule {
  HttpModule(HttpClient client, {bool isUseRetryInterceptor = false}) {
    _client = client;
    if (isUseRetryInterceptor) {
      _client.interceptors.add(_retryInterceptor(dio: _client));
    }
  }

  @protected
  late HttpClient _client;

  @protected
  Log get log => getIt<Log>();
  Future<PackageInfo> get _packageInfo => PackageInfo.fromPlatform();

  Future<String> get authorizationToken => Future.value('');

  Future<Map<String, String>> get headersWithAuthorization async {
    var token = await authorizationToken;
    return {
      "Authorization": token,
      'Content-Type': 'application/json',
      'X-APP-VERSION': await getAppVersion(),
    };
  }

  Future<Map<String, dynamic>> get headers async => {
        'Content-Type': 'application/json',
        'X-APP-VERSION': await getAppVersion(),
      };

  //can add more string if needed
  Future<String> getAppVersion() async =>
      '${io.Platform.isAndroid ? 'android' : 'ios'}/${(await _packageInfo).version}';

  Future<dynamic> _safeCallApi<T>(
    Future<Response<T>> call,
  ) async {
    try {
      var response = await call;

      return responseParser(response);
    }

    /* On Known Error */
    on DioException catch (dioErr) {
      String message = dioErr.message ?? '';
      int? code = dioErr.response?.statusCode;

      log.console('Dio Error [${dioErr.type}]', type: LogType.fatal);
      log.console(message, type: LogType.fatal);

      List<DioExceptionType> dioTimeout = [
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.sendTimeout,
      ];

      if (dioTimeout.any((e) => dioErr.type == e)) {
        throw NetworkException(dioErr.message);
      }

      if (code == null) {
        throw ClientException(message);
      } else if (code >= 400 && code < 500) {
        throw ErrorRequestException(code, dioErr.response?.data ?? message);
      } else if (code >= 500) {
        throw ServerException();
      } else {
        throw ClientException(message);
      }
    } catch (e) {
      log.console(e.toString());
      throw ServerException();
    }
  }

  dynamic responseParser(Response response) {
    dynamic data;

    try {
      if (response.data is List) {
        data = List.of(<Map<String, dynamic>>[]);

        response.data.forEach(
          (e) => data.add(e),
        );
      } else {
        data = json.decode(response.toString()) as Map<String, dynamic>;
      }
    } catch (e) {
      log.console('Parse Error', type: LogType.fatal);
      log.console(
        'Response format isn\'t as expected | ${response.realUri}',
        type: LogType.fatal,
      );
    }

    return data;
  }

  Future<dynamic> getMethod(
    String endpoint, {
    Map<String, dynamic>? param,
    bool needAuthorization = true,
    bool cache = false,
    void Function(int, int)? onReceiveProgress,
  }) async {
    late Options options;
    /* Set Cache Options */
    if (!cache) {
      options = CacheOptions(
        store: MemCacheStore(),
        policy: CachePolicy.request,
        maxStale: const Duration(days: 1),
        allowPostMethod: false,
      ).toOptions();
    } else {
      options = Options();
    }

    /* Set Headers */
    options = options.copyWith(
      headers:
          needAuthorization ? await headersWithAuthorization : await headers,
    );

    var response = await _safeCallApi(
      _client.get(
        endpoint,
        queryParameters: param,
        options: options,
        onReceiveProgress: onReceiveProgress,
      ),
    );

    return response;
  }

  Future<Map<String, dynamic>> postMethod(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? param,
    bool needAuthorization = true,
  }) async {
    var options = Options(headers: await headers);
    options = options.copyWith(
      headers:
          needAuthorization ? await headersWithAuthorization : await headers,
    );

    var response = await _safeCallApi(
      _client.post(
        endpoint,
        data: body,
        queryParameters: param,
        options: options,
      ),
    );

    return response;
  }

  Future<Map<String, dynamic>> postMethodByForm(
    String endpoint, {
    FormData? body,
    Map<String, dynamic>? param,
    bool needAuthorization = true,
  }) async {
    var options = Options(headers: await headers);
    options = options.copyWith(
      headers:
          needAuthorization ? await headersWithAuthorization : await headers,
    );

    var response = await _safeCallApi(
      _client.post(
        endpoint,
        data: body,
        queryParameters: param,
        options: options,
      ),
    );

    return response;
  }

  Future<Map<String, dynamic>> putMethod(
    String endpoint, {
    dynamic body,
    bool needAuthorization = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    var options = Options(headers: await headers);

    var response = await _safeCallApi(
      _client.put(
        endpoint,
        data: body,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );

    return response;
  }

  Future<Map<String, dynamic>> deleteMethod(
    String endpoint, {
    Map<String, dynamic>? body,
    bool needAuthorization = true,
  }) async {
    var options = Options(headers: await headers);

    var response = await _safeCallApi(
      _client.delete(
        endpoint,
        data: body,
        options: options,
      ),
    );

    return response;
  }

  Future<Map<String, dynamic>> patchMethod(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? param,
    bool needAuthorization = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    var options = Options(headers: await headers);

    var response = await _safeCallApi(
      _client.patch(
        endpoint,
        data: body,
        queryParameters: param,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );

    return response;
  }

  RetryInterceptor _retryInterceptor({
    required Dio dio,
    int retries = 7,
    int exponential = 3,
    int maximumBackoff = 5000,
  }) {
    return RetryInterceptor(
      dio: dio,
      logPrint: dev.log,
      retries: retries,
      retryDelays: List.generate(
        retries,
        (index) => Duration(
          // https://cloud.google.com/iot/docs/how-tos/exponential-backoff
          milliseconds: math.min(
            (exponential ^ (index + 1)) +
                (index * 1000 + math.Random().nextInt(1000)),
            maximumBackoff,
          ),
        ),
      ),
    );
  }
}
