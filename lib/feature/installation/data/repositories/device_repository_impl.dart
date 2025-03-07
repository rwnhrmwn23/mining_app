import 'package:injectable/injectable.dart';

import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/remote_device_datasource.dart';
import '../models/device_model.dart';

@LazySingleton(as: DeviceRepository)
class DeviceRepositoryImpl implements DeviceRepository {
  final RemoteDeviceDataSource remoteDataSource;

  DeviceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Device?> checkDeviceStatus(String deviceId) async {
    try {
      final model = await remoteDataSource.checkDeviceStatus(deviceId);
      if (model == null) return null;
      return Device(id: model.id, isActive: model.isActive, activatedAt: model.activatedAt);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Device> registerDevice(Device device) async {
    try {
      final model = await remoteDataSource.registerDevice(
          DeviceModel(id: device.id, isActive: false));
      return Device(id: model.id, isActive: model.isActive, activatedAt: model.activatedAt);
    } catch (e) {
      rethrow;
    }
  }
}