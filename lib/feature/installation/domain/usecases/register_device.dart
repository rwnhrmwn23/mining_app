import 'package:injectable/injectable.dart';

import '../entities/device.dart';
import '../repositories/device_repository.dart';

@lazySingleton
class RegisterDevice {
  final DeviceRepository repository;

  RegisterDevice(this.repository);

  Future<Device> call(Device device) async {
    return await repository.registerDevice(device);
  }
}