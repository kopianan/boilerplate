import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kopianan_boilerplate/domain/example/i_get_data.dart';
import 'package:kopianan_boilerplate/infrastructure/core/module/dio_http_module.dart';
import 'package:kopianan_boilerplate/injection.dart';


@LazySingleton(as: IExample)
class ExampleRepository implements IExample {
  static final client = getIt<DioHttpModule>();

  @override
  Future<Either<String, String>> getData() async {
    String endPoint = "https://pokeapi.co/api/v2/pokemon/ditto";
    final response = await client.getMethod(endPoint);

    print(response.toString());
    return right("");
  }
}
