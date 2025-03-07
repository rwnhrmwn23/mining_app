abstract class DeviceEvent {}

class CheckDeviceStatusEvent extends DeviceEvent {
  final String deviceId;
  CheckDeviceStatusEvent(this.deviceId);
}

class RegisterDeviceEvent extends DeviceEvent {
  final String deviceId;
  RegisterDeviceEvent(this.deviceId);
}