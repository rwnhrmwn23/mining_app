// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;

import '../../feature/dashboard/data/datasources/remote_message_datasource.dart'
    as _i9;
import '../../feature/dashboard/data/datasources/remote_subject_datasource.dart'
    as _i10;
import '../../feature/dashboard/data/models/message_model.dart' as _i6;
import '../../feature/dashboard/data/repositories/message_repository_impl.dart'
    as _i20;
import '../../feature/dashboard/data/repositories/subject_repository_impl.dart'
    as _i12;
import '../../feature/dashboard/domain/repositories/message_repository.dart'
    as _i19;
import '../../feature/dashboard/domain/repositories/subject_repository.dart'
    as _i11;
import '../../feature/dashboard/domain/usecases/get_messages.dart' as _i25;
import '../../feature/dashboard/domain/usecases/get_subjects.dart' as _i15;
import '../../feature/dashboard/presentation/bloc/message/message_bloc.dart'
    as _i27;
import '../../feature/dashboard/presentation/bloc/subject/subject_bloc.dart'
    as _i22;
import '../../feature/installation/data/datasources/remote_device_datasource.dart'
    as _i7;
import '../../feature/installation/data/repositories/device_repository_impl.dart'
    as _i14;
import '../../feature/installation/domain/repositories/device_repository.dart'
    as _i13;
import '../../feature/installation/domain/usecases/check_device_status.dart'
    as _i23;
import '../../feature/installation/domain/usecases/register_device.dart'
    as _i21;
import '../../feature/installation/presentation/bloc/device_bloc.dart' as _i24;
import '../../feature/login/data/datasources/remote_login_datasource.dart'
    as _i8;
import '../../feature/login/data/repositories/login_repository_impl.dart'
    as _i17;
import '../../feature/login/domain/repositories/login_repository.dart' as _i16;
import '../../feature/login/domain/usecases/login_tablet.dart' as _i18;
import '../../feature/login/presentation/bloc/login_bloc.dart' as _i26;
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
  gh.factory<_i6.MessageModel>(() => _i6.MessageModel(
        id: get<String>(),
        equipmentId: get<String>(),
        senderNik: get<String>(),
        isRead: get<bool>(),
        message: get<String>(),
        createdAt: get<DateTime>(),
        updatedAt: get<DateTime>(),
        senderName: get<String>(),
        deviceType: get<String>(),
        categoryId: get<String>(),
        equipmentCode: get<String>(),
        fleetId: get<String>(),
        equipmentSiteId: get<String>(),
        categoryName: get<String>(),
      ));
  gh.lazySingleton<_i7.RemoteDeviceDataSource>(
      () => _i7.RemoteDeviceDataSourceImpl(client: get<_i3.ApiClient>()));
  gh.lazySingleton<_i8.RemoteLoginDataSource>(
      () => _i8.RemoteLoginDataSourceImpl(
            client: get<_i3.ApiClient>(),
            cookieManager: get<_i5.CookieManager>(),
          ));
  gh.lazySingleton<_i9.RemoteMessageDataSource>(
      () => _i9.RemoteMessageDataSourceImpl(
            client: get<_i3.ApiClient>(),
            cookieManager: get<_i5.CookieManager>(),
          ));
  gh.lazySingleton<_i10.RemoteSubjectDataSource>(
      () => _i10.RemoteSubjectDataSourceImpl(
            client: get<_i3.ApiClient>(),
            cookieManager: get<_i5.CookieManager>(),
          ));
  gh.lazySingleton<_i11.SubjectRepository>(
      () => _i12.SubjectRepositoryImpl(get<_i10.RemoteSubjectDataSource>()));
  gh.lazySingleton<_i13.DeviceRepository>(() => _i14.DeviceRepositoryImpl(
      remoteDataSource: get<_i7.RemoteDeviceDataSource>()));
  gh.lazySingleton<_i15.GetSubjects>(
      () => _i15.GetSubjects(get<_i11.SubjectRepository>()));
  gh.lazySingleton<_i16.LoginRepository>(() => _i17.LoginRepositoryImpl(
      remoteDataSource: get<_i8.RemoteLoginDataSource>()));
  gh.lazySingleton<_i18.LoginTablet>(
      () => _i18.LoginTablet(get<_i16.LoginRepository>()));
  gh.lazySingleton<_i19.MessageRepository>(
      () => _i20.MessageRepositoryImpl(get<_i9.RemoteMessageDataSource>()));
  gh.lazySingleton<_i21.RegisterDevice>(
      () => _i21.RegisterDevice(get<_i13.DeviceRepository>()));
  gh.lazySingleton<_i22.SubjectBloc>(
      () => _i22.SubjectBloc(get<_i15.GetSubjects>()));
  gh.lazySingleton<_i23.CheckDeviceStatus>(
      () => _i23.CheckDeviceStatus(get<_i13.DeviceRepository>()));
  gh.lazySingleton<_i24.DeviceBloc>(() => _i24.DeviceBloc(
        get<_i23.CheckDeviceStatus>(),
        get<_i21.RegisterDevice>(),
      ));
  gh.lazySingleton<_i25.GetMessages>(
      () => _i25.GetMessages(get<_i19.MessageRepository>()));
  gh.lazySingleton<_i26.LoginBloc>(
      () => _i26.LoginBloc(get<_i18.LoginTablet>()));
  gh.lazySingleton<_i27.MessageBloc>(
      () => _i27.MessageBloc(get<_i25.GetMessages>()));
  return get;
}
