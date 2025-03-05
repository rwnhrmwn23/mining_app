import '../entities/device.dart';
import '../repositories/device_repository.dart';

class CheckDeviceStatus {
  final DeviceRepository repository;

  CheckDeviceStatus(this.repository);

  Future<Device?> call(String deviceId) async {
    return await repository.checkDeviceStatus(deviceId);
  }
}