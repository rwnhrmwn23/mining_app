import 'package:injectable/injectable.dart';

import '../../domain/entities/login_responses.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/remote_login_datasource.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final RemoteLoginDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResponse> loginTablet(String unitId, String nik, String shiftId, int loginType) async {
    try {
      final model = await remoteDataSource.loginTablet(unitId, nik, shiftId, loginType);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}