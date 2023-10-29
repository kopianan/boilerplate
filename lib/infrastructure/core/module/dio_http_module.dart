import 'package:injectable/injectable.dart';
import 'package:kopianan_boilerplate/infrastructure/core/networks/http/http_client.dart';
import 'package:kopianan_boilerplate/infrastructure/core/networks/http/http_module.dart';
import 'package:kopianan_boilerplate/injection.dart';

@LazySingleton()
class DioHttpModule extends HttpModule {
  DioHttpModule()
      : super(getIt<HttpClient>(instanceName: 'dioHttpClient'),
            isUseRetryInterceptor: false);

  // @override
  // Future<String> get authorizationToken async {
  //   return "Bearer ";
  // }
}
