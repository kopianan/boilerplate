import 'package:dartz/dartz.dart';

abstract class IExample {
  Future<Either<String, String>> getData();
}
