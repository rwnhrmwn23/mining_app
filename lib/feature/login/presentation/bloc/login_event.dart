import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String unitId;
  final String nik;
  final String shiftId;
  final int loginType;

  const LoginSubmitted({
    required this.unitId,
    required this.nik,
    required this.shiftId,
    required this.loginType,
  });

  @override
  List<Object?> get props => [unitId, nik, shiftId, loginType];
}