// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i7;

import 'application/cubit/example_cubit.dart' as _i8;
import 'core/di/register_module.dart' as _i10;
import 'core/log.dart' as _i9;
import 'domain/example/i_get_data.dart' as _i5;
import 'infrastructure/core/module/dio_http_module.dart' as _i3;
import 'infrastructure/core/networks/http/http_client.dart' as _i4;
import 'infrastructure/example/example_repository.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i3.DioHttpModule>(() => _i3.DioHttpModule());
    gh.factory<_i4.HttpClient>(
      () => registerModule.dioHttpClient,
      instanceName: 'dioHttpClient',
    );
    gh.lazySingleton<_i5.IExample>(() => _i6.ExampleRepository());
    gh.factory<_i7.Logger>(() => registerModule.logger);
    gh.factory<_i8.ExampleCubit>(() => _i8.ExampleCubit(gh<_i5.IExample>()));
    gh.lazySingleton<_i9.Log>(() => _i9.Log(gh<_i7.Logger>()));
    return this;
  }
}

class _$RegisterModule extends _i10.RegisterModule {}
