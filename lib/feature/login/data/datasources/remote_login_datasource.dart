import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/cookie_manager.dart';
import '../models/login_response_model.dart';

abstract class RemoteLoginDataSource {
  Future<LoginResponseModel> loginTablet(String unitId, String nik, String shiftId, int loginType);
}

@LazySingleton(as: RemoteLoginDataSource)
class RemoteLoginDataSourceImpl implements RemoteLoginDataSource {
  final ApiClient client;
  final CookieManager cookieManager;

  RemoteLoginDataSourceImpl({required this.client, required this.cookieManager});

  @override
  Future<LoginResponseModel> loginTablet(String unitId, String nik, String shiftId, int loginType) async {
    final response = await client.post(
      'login-tablet-unit',
      body: {
        'unit_id': unitId,
        'nik': nik,
        'shift_id': shiftId,
        'login_type': loginType,
      },
    );

    if (response.statusCode == 200) {
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        final token = _extractTokenFromCookies(cookies);
        if (token != null) {
          print('remote token2: $token');
          await cookieManager.saveToken(token);
        }
      }

      final data = jsonDecode(response.body);
      return LoginResponseModel.fromJson(data);
    } else if (response.statusCode == 400) {
      throw Exception('User not found');
    }
    throw Exception('Failed to login: ${response.statusCode}');
  }

  String? _extractTokenFromCookies(String cookies) {
    final cookieList = cookies.split(';');
    for (var cookie in cookieList) {
      if (cookie.trim().startsWith('token=')) {
        var token = cookie.trim().split('=')[1];
        return token;
      }
    }
    return null;
  }
}