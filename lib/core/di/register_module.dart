import 'package:injectable/injectable.dart';
import 'package:kopianan_boilerplate/infrastructure/core/networks/http/http_client.dart';
import 'package:kopianan_boilerplate/infrastructure/core/networks/http/http_setting.dart';
import 'package:logger/logger.dart';

@module
abstract class RegisterModule {
  @Named('dioHttpClient')
  HttpClient get dioHttpClient => HttpClient.init(HttpSetting(
        baseUrl: '',
      ));

  Logger get logger => Logger();
}
