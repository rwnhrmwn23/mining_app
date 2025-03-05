import 'dart:convert';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../models/device_model.dart';

abstract class RemoteDeviceDataSource {
  Future<DeviceModel?> checkDeviceStatus(String deviceId); // Updated to return a single DeviceModel or null
  Future<DeviceModel> registerDevice(DeviceModel device);
}

@LazySingleton(as: RemoteDeviceDataSource)
class RemoteDeviceDataSourceImpl implements RemoteDeviceDataSource {
  final ApiClient client;

  RemoteDeviceDataSourceImpl({required this.client});

  @override
  Future<DeviceModel?> checkDeviceStatus(String deviceId) async {
    final response = await client.get(
      '${ApiClient.baseUrl}equipments/devices?id=$deviceId&limit=1000',
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      final devices = data.map((d) => DeviceModel.fromJson(d)).toList();
      try {
        return devices.where((element) => element.id == deviceId).first;
      } catch (e) {
        return null;
      }
    }
    throw Exception('Failed to check device: ${response.statusCode}');
  }

  @override
  Future<DeviceModel> registerDevice(DeviceModel device) async {
    final response = await client.post(
      '${ApiClient.baseUrl}equipments/devices',
      body: device.toJson(),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      return DeviceModel.fromJson(data);
    }
    throw Exception('Failed to register device: ${response.statusCode}');
  }
}