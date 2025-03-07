// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;

import '../../feature/installation/data/datasources/remote_device_datasource.dart'
    as _i5;
import '../../feature/installation/data/repositories/device_repository_impl.dart'
    as _i8;
import '../../feature/installation/domain/repositories/device_repository.dart'
    as _i7;
import '../../feature/installation/domain/usecases/check_device_status.dart'
    as _i13;
import '../../feature/installation/domain/usecases/register_device.dart'
    as _i12;
import '../../feature/installation/presentation/bloc/device_bloc.dart' as _i14;
import '../../feature/login/data/datasources/remote_login_datasource.dart'
    as _i6;
import '../../feature/login/data/repositories/login_repository_impl.dart'
    as _i10;
import '../../feature/login/domain/repositories/login_repository.dart' as _i9;
import '../../feature/login/domain/usecases/login_tablet.dart' as _i11;
import '../../feature/login/presentation/bloc/login_bloc.dart' as _i15;
import '../network/api_client.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i3.ApiClient>(() => _i3.ApiClient(get<_i4.Client>()));
  gh.lazySingleton<_i5.RemoteDeviceDataSource>(
      () => _i5.RemoteDeviceDataSourceImpl(client: get<_i3.ApiClient>()));
  gh.lazySingleton<_i6.RemoteLoginDataSource>(
      () => _i6.RemoteLoginDataSourceImpl(client: get<_i3.ApiClient>()));
  gh.lazySingleton<_i7.DeviceRepository>(() => _i8.DeviceRepositoryImpl(
      remoteDataSource: get<_i5.RemoteDeviceDataSource>()));
  gh.lazySingleton<_i9.LoginRepository>(() => _i10.LoginRepositoryImpl(
      remoteDataSource: get<_i6.RemoteLoginDataSource>()));
  gh.lazySingleton<_i11.LoginTablet>(
      () => _i11.LoginTablet(get<_i9.LoginRepository>()));
  gh.lazySingleton<_i12.RegisterDevice>(
      () => _i12.RegisterDevice(get<_i7.DeviceRepository>()));
  gh.lazySingleton<_i13.CheckDeviceStatus>(
      () => _i13.CheckDeviceStatus(get<_i7.DeviceRepository>()));
  gh.lazySingleton<_i14.DeviceBloc>(() => _i14.DeviceBloc(
        get<_i13.CheckDeviceStatus>(),
        get<_i12.RegisterDevice>(),
      ));
  gh.lazySingleton<_i15.LoginBloc>(
      () => _i15.LoginBloc(get<_i11.LoginTablet>()));
  return get;
}
