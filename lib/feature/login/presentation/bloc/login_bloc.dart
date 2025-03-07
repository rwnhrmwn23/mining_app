import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mining_app/feature/login/domain/usecases/login_tablet.dart';
import 'login_event.dart';
import 'login_state.dart';

@lazySingleton
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginTablet loginTablet;

  LoginBloc(this.loginTablet) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response = await loginTablet(
        event.unitId,
        event.nik,
        event.shiftId,
        event.loginType,
      );
      if (response.isActive == true) {
        emit(LoginSuccess(response));
      } else {
        emit(LoginFailure('User is not active'));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}