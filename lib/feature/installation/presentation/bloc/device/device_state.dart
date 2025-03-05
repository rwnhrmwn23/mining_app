abstract class DeviceState {}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceRegistered extends DeviceState {}

class DeviceWaitingActivation extends DeviceState {}

class DeviceActive extends DeviceState {}

class DeviceError extends DeviceState {
  final String message;
  DeviceError(this.message);
}