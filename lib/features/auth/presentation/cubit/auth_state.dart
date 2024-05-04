part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class SelectSignInState extends AuthState {
  @override
  List<Object> get props => [];
}

class SelectSignUpState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final BaseResponse response;

  const LoginSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class LoginError extends AuthState {
  final String message;

  LoginError(this.message);

  @override
  List<Object> get props => [message];
}
