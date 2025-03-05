import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/local_storage.dart';
import '../../../domain/entities/device.dart';
import '../../../domain/usecases/check_device_status.dart';
import '../../../domain/usecases/register_device.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final CheckDeviceStatus checkDeviceStatus;
  final RegisterDevice registerDevice;

  DeviceBloc(this.checkDeviceStatus, this.registerDevice)
      : super(DeviceInitial()) {
    on<CheckDeviceStatusEvent>(_onCheckDeviceStatus);
    on<RegisterDeviceEvent>(_onRegisterDevice);
  }

  Future<void> _onCheckDeviceStatus(
      CheckDeviceStatusEvent event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      final savedDeviceId = await LocalStorage.getDeviceId();
      final device = await checkDeviceStatus(event.deviceId);
      if (device == null) {
        add(RegisterDeviceEvent(savedDeviceId.toString()));
      } else if (device.isActive == true) {
        emit(DeviceActive());
      } else {
        emit(DeviceWaitingActivation());
      }
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onRegisterDevice(
      RegisterDeviceEvent event, Emitter<DeviceState> emit) async {
    emit(DeviceLoading());
    try {
      final device = await registerDevice(Device(id: event.deviceId, isActive: false));
      if (device.isActive) {
        emit(DeviceActive());
      } else {
        emit(DeviceWaitingActivation());
      }
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
}