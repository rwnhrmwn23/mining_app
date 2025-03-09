// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;

import '../../feature/dashboard/data/datasources/remote_message_datasource.dart'
    as _i10;
import '../../feature/dashboard/data/datasources/remote_subject_datasource.dart'
    as _i11;
import '../../feature/dashboard/data/models/message_model.dart' as _i6;
import '../../feature/dashboard/data/repositories/message_repository_impl.dart'
    as _i21;
import '../../feature/dashboard/data/repositories/subject_repository_impl.dart'
    as _i13;
import '../../feature/dashboard/domain/repositories/message_repository.dart'
    as _i20;
import '../../feature/dashboard/domain/repositories/subject_repository.dart'
    as _i12;
import '../../feature/dashboard/domain/usecases/get_messages.dart' as _i27;
import '../../feature/dashboard/domain/usecases/get_subjects.dart' as _i16;
import '../../feature/dashboard/domain/usecases/sent_messages.dart' as _i23;
import '../../feature/dashboard/presentation/bloc/message/message_bloc.dart'
    as _i29;
import '../../feature/dashboard/presentation/bloc/subject/subject_bloc.dart'
    as _i24;
import '../../feature/dashboard/presentation/socket/message_web_socket.dart'
    as _i7;
import '../../feature/installation/data/datasources/remote_device_datasource.dart'
    as _i8;
import '../../feature/installation/data/repositories/device_repository_impl.dart'
    as _i15;
import '../../feature/installation/domain/repositories/device_repository.dart'
    as _i14;
import '../../feature/installation/domain/usecases/check_device_status.dart'
    as _i25;
import '../../feature/installation/domain/usecases/register_device.dart'
    as _i22;
import '../../feature/installation/presentation/bloc/device_bloc.dart' as _i26;
import '../../feature/login/data/datasources/remote_login_datasource.dart'
    as _i9;
import '../../feature/login/data/repositories/login_repository_impl.dart'
    as _i18;
import '../../feature/login/domain/repositories/login_repository.dart' as _i17;
import '../../feature/login/domain/usecases/login_tablet.dart' as _i19;
import '../../feature/login/presentation/bloc/login_bloc.dart' as _i28;
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
  gh.lazySingleton<_i7.MessageWebSocket>(() => _i7.MessageWebSocket());
  gh.lazySingleton<_i8.RemoteDeviceDataSource>(
      () => _i8.RemoteDeviceDataSourceImpl(client: get<_i3.ApiClient>()));
  gh.lazySingleton<_i9.RemoteLoginDataSource>(
      () => _i9.RemoteLoginDataSourceImpl(
            client: get<_i3.ApiClient>(),
            cookieManager: get<_i5.CookieManager>(),
          ));
  gh.lazySingleton<_i10.RemoteMessageDataSource>(
      () => _i10.RemoteMessageDataSourceImpl(
            client: get<_i3.ApiClient>(),
            cookieManager: get<_i5.CookieManager>(),
          ));
  gh.lazySingleton<_i11.RemoteSubjectDataSource>(
      () => _i11.RemoteSubjectDataSourceImpl(
            client: get<_i3.ApiClient>(),
            cookieManager: get<_i5.CookieManager>(),
          ));
  gh.lazySingleton<_i12.SubjectRepository>(
      () => _i13.SubjectRepositoryImpl(get<_i11.RemoteSubjectDataSource>()));
  gh.lazySingleton<_i14.DeviceRepository>(() => _i15.DeviceRepositoryImpl(
      remoteDataSource: get<_i8.RemoteDeviceDataSource>()));
  gh.lazySingleton<_i16.GetSubjects>(
      () => _i16.GetSubjects(get<_i12.SubjectRepository>()));
  gh.lazySingleton<_i17.LoginRepository>(() => _i18.LoginRepositoryImpl(
      remoteDataSource: get<_i9.RemoteLoginDataSource>()));
  gh.lazySingleton<_i19.LoginTablet>(
      () => _i19.LoginTablet(get<_i17.LoginRepository>()));
  gh.lazySingleton<_i20.MessageRepository>(
      () => _i21.MessageRepositoryImpl(get<_i10.RemoteMessageDataSource>()));
  gh.lazySingleton<_i22.RegisterDevice>(
      () => _i22.RegisterDevice(get<_i14.DeviceRepository>()));
  gh.lazySingleton<_i23.SentMessage>(
      () => _i23.SentMessage(get<_i20.MessageRepository>()));
  gh.lazySingleton<_i24.SubjectBloc>(
      () => _i24.SubjectBloc(get<_i16.GetSubjects>()));
  gh.lazySingleton<_i25.CheckDeviceStatus>(
      () => _i25.CheckDeviceStatus(get<_i14.DeviceRepository>()));
  gh.lazySingleton<_i26.DeviceBloc>(() => _i26.DeviceBloc(
        get<_i25.CheckDeviceStatus>(),
        get<_i22.RegisterDevice>(),
      ));
  gh.lazySingleton<_i27.GetMessages>(
      () => _i27.GetMessages(get<_i20.MessageRepository>()));
  gh.lazySingleton<_i28.LoginBloc>(
      () => _i28.LoginBloc(get<_i19.LoginTablet>()));
  gh.lazySingleton<_i29.MessageBloc>(() => _i29.MessageBloc(
        get<_i27.GetMessages>(),
        get<_i23.SentMessage>(),
      ));
  return get;
}
