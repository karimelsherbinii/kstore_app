part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}


class LoginLoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState();
  @override
  List<Object> get props => [];
}

class LoginErrorState extends LoginState {
  final String message;
  const LoginErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class AuthenticatedState extends LoginState {
  final User authenticatedUser;
  const AuthenticatedState({required this.authenticatedUser});
  @override
  List<Object> get props => [authenticatedUser];
}

class UnAuthenticatedState extends LoginState {
  @override
  List<Object> get props => [];
}

class LogoutSuccessState extends LoginState {
  final String message;
  const LogoutSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class LogoutErrorState extends LoginState {
  final String message;
  const LogoutErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class LogoutLoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

class LogoutLocallySuccessState extends LoginState {
  final String message;
  const LogoutLocallySuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class LogoutLocallyErrorState extends LoginState {
  final String message;
  const LogoutLocallyErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class LogoutLocallyLoadingState extends LoginState {
  @override
  List<Object> get props => [];
}