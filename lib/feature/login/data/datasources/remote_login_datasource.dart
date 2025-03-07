import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_response_model.dart';

abstract class RemoteLoginDataSource {
  Future<LoginResponseModel> loginTablet(String unitId, String nik, String shiftId, int loginType);
}

@LazySingleton(as: RemoteLoginDataSource)
class RemoteLoginDataSourceImpl implements RemoteLoginDataSource {
  final ApiClient client;

  RemoteLoginDataSourceImpl({required this.client});

  @override
  Future<LoginResponseModel> loginTablet(String unitId, String nik, String shiftId, int loginType) async {
    final response = await client.post(
      '${ApiClient.baseUrl}login-tablet-unit',
      body: {
        'unit_id': unitId,
        'nik': nik,
        'shift_id': shiftId,
        'login_type': loginType,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResponseModel.fromJson(data);
    } else if (response.statusCode == 400) {
      throw Exception('User not found');
    }
    throw Exception('Failed to login: ${response.statusCode}');
  }
}