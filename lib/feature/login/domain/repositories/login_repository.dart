import '../entities/login_responses.dart';

abstract class LoginRepository {
  Future<LoginResponse> loginTablet(String unitId, String nik, String shiftId, int loginType);
}