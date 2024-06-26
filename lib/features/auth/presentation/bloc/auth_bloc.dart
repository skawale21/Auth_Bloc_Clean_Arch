import 'package:blog_app_clean_arch/features/auth/domain/entities/user.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticatinBloc extends Bloc<AuthEvent, AuthenticatinState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;

  AuthenticatinBloc(
      {required UserLogin userLogin, required UserSignUp userSignUp})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
  }

  //bloc functions

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthenticatinState> emit) async {
    emit(AuthLoading());

    final res = await _userSignUp(UserSignUpParams(
      email: event.email,
      password: event.password,
      name: event.name,
    ));

    res.fold((l) => emit(AuthFailure(message: l.message)), (user) {
      debugPrint(user.toString());
      return emit(AuthSuccess(user: user));
    });
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthenticatinState> emit) async {
    emit(AuthLoading());

    final res = await _userLogin(UserLoginParams(
      email: event.email,
      password: event.password,
    ));

    res.fold((l) => emit(AuthFailure(message: l.message)), (user) {
      debugPrint(user.toString());
      return emit(AuthSuccess(user: user));
    });
  }
}
