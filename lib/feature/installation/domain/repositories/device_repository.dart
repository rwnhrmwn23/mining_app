import '../entities/device.dart';

abstract class DeviceRepository {
  Future<Device?> checkDeviceStatus(String deviceId);
  Future<Device> registerDevice(Device device);
}