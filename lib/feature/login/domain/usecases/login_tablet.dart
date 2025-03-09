import 'package:injectable/injectable.dart';

import '../entities/login_responses.dart';
import '../repositories/login_repository.dart';

@lazySingleton
class LoginTablet {
  final LoginRepository repository;

  LoginTablet(this.repository);

  Future<LoginResponse> call(String unitId, String nik, String shiftId, int loginType) async {
    return await repository.loginTablet(unitId, nik, shiftId, loginType);
  }
}