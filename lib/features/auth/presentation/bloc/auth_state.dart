part of 'auth_bloc.dart';

@immutable
sealed class AuthenticatinState {}

final class AuthInitial extends AuthenticatinState {}

final class AuthLoading extends AuthenticatinState {}

final class AuthSuccess extends AuthenticatinState {
  final User user;

  AuthSuccess({required this.user});
}

final class AuthFailure extends AuthenticatinState {
  final String message;

  AuthFailure({required this.message});
}
