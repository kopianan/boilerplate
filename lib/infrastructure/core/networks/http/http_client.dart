import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:kopianan_boilerplate/infrastructure/core/networks/http/http_setting.dart';
import 'package:kopianan_boilerplate/infrastructure/core/networks/interceptor/logging_interceptor.dart';

class HttpClient with DioMixin implements Dio {
  /* Private Instance */
  HttpClient._(HttpSetting settings) {
    options = BaseOptions(
      baseUrl: settings.baseUrl,
      contentType: settings.contentType,
      connectTimeout: Duration(milliseconds: settings.timeout.connectTimeout),
      sendTimeout: Duration(milliseconds: settings.timeout.sendTimeout),
      receiveTimeout: Duration(milliseconds: settings.timeout.receiveTimeout),
    );

    httpClientAdapter = IOHttpClientAdapter();

    interceptors.addAll(
      settings.interceptors ?? defaultInterceptors,
    );

    interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: HiveCacheStore(null),
          policy: CachePolicy.request,
          maxStale: const Duration(days: 1),
          allowPostMethod: false,
        ),
      ),
    );
  }

  /* Instance Getter */
  static HttpClient init([HttpSetting? settings]) {
    return HttpClient._(
      //!Setting this
      settings ?? HttpSetting(baseUrl: "BASE URL"),
    );
  }

  /* Default Interceptors */
  static List<Interceptor> defaultInterceptors = [
    LoggingInterceptor(),
  ];
}
