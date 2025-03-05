// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;

import '../../../core/network/api_client.dart' as _i3;
import '../data/datasources/remote_device_datasource.dart' as _i5;
import '../data/repositories/device_repository_impl.dart' as _i7;
import '../domain/repositories/device_repository.dart' as _i6;
import '../domain/usecases/check_device_status.dart' as _i9;
import '../domain/usecases/register_device.dart' as _i8;
import '../presentation/bloc/device/device_bloc.dart'
    as _i10; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i6.DeviceRepository>(() => _i7.DeviceRepositoryImpl(
      remoteDataSource: get<_i5.RemoteDeviceDataSource>()));
  gh.lazySingleton<_i8.RegisterDevice>(
      () => _i8.RegisterDevice(get<_i6.DeviceRepository>()));
  gh.lazySingleton<_i9.CheckDeviceStatus>(
      () => _i9.CheckDeviceStatus(get<_i6.DeviceRepository>()));
  gh.factory<_i10.DeviceBloc>(() => _i10.DeviceBloc(
        get<_i9.CheckDeviceStatus>(),
        get<_i8.RegisterDevice>(),
      ));
  return get;
}
