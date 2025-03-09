// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;

import '../../feature/dashboard/data/datasources/remote_subject_datasource.dart'
    as _i8;
import '../../feature/dashboard/data/repositories/subject_repository_impl.dart'
    as _i10;
import '../../feature/dashboard/domain/repositories/subject_repository.dart'
    as _i9;
import '../../feature/dashboard/domain/usecases/get_subjects.dart' as _i13;
import '../../feature/dashboard/presentation/bloc/subject_bloc.dart' as _i18;
import '../../feature/installation/data/datasources/remote_device_datasource.dart'
    as _i6;
import '../../feature/installation/data/repositories/device_repository_impl.dart'
    as _i12;
import '../../feature/installation/domain/repositories/device_repository.dart'
    as _i11;
import '../../feature/installation/domain/usecases/check_device_status.dart'
    as _i19;
import '../../feature/installation/domain/usecases/register_device.dart'
    as _i17;
import '../../feature/installation/presentation/bloc/device_bloc.dart' as _i20;
import '../../feature/login/data/datasources/remote_login_datasource.dart'
    as _i7;
import '../../feature/login/data/repositories/login_repository_impl.dart'
    as _i15;
import '../../feature/login/domain/repositories/login_repository.dart' as _i14;
import '../../feature/login/domain/usecases/login_tablet.dart' as _i16;
import '../../feature/login/presentation/bloc/login_bloc.dart' as _i21;
import '../network/api_client.dart' as _i3;
import '../storage/cookie_manager.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i5.CookieManager>(() => _i5.CookieManager());
  gh.lazySingleton<_i6.RemoteDeviceDataSource>(
      () => _i6.RemoteDeviceDataSourceImpl(client: get<_i3.ApiClient>()));
  gh.lazySingleton<_i7.RemoteLoginDataSource>(
      () => _i7.RemoteLoginDataSourceImpl(
            client: get<_i3.ApiClient>(),
            cookieManager: get<_i5.CookieManager>(),
          ));
  gh.lazySingleton<_i8.RemoteSubjectDataSource>(
      () => _i8.RemoteSubjectDataSourceImpl(
            client: get<_i3.ApiClient>(),
            cookieManager: get<_i5.CookieManager>(),
          ));
  gh.lazySingleton<_i9.SubjectRepository>(
      () => _i10.SubjectRepositoryImpl(get<_i8.RemoteSubjectDataSource>()));
  gh.lazySingleton<_i11.DeviceRepository>(() => _i12.DeviceRepositoryImpl(
      remoteDataSource: get<_i6.RemoteDeviceDataSource>()));
  gh.lazySingleton<_i13.GetSubjects>(
      () => _i13.GetSubjects(get<_i9.SubjectRepository>()));
  gh.lazySingleton<_i14.LoginRepository>(() => _i15.LoginRepositoryImpl(
      remoteDataSource: get<_i7.RemoteLoginDataSource>()));
  gh.lazySingleton<_i16.LoginTablet>(
      () => _i16.LoginTablet(get<_i14.LoginRepository>()));
  gh.lazySingleton<_i17.RegisterDevice>(
      () => _i17.RegisterDevice(get<_i11.DeviceRepository>()));
  gh.lazySingleton<_i18.SubjectBloc>(
      () => _i18.SubjectBloc(get<_i13.GetSubjects>()));
  gh.lazySingleton<_i19.CheckDeviceStatus>(
      () => _i19.CheckDeviceStatus(get<_i11.DeviceRepository>()));
  gh.lazySingleton<_i20.DeviceBloc>(() => _i20.DeviceBloc(
        get<_i19.CheckDeviceStatus>(),
        get<_i17.RegisterDevice>(),
      ));
  gh.lazySingleton<_i21.LoginBloc>(
      () => _i21.LoginBloc(get<_i16.LoginTablet>()));
  return get;
}
