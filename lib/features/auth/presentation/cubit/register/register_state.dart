part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterLoadingState extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterSuccessState extends RegisterState {
  final BaseResponse response;

  const RegisterSuccessState(this.response);

  @override
  List<Object> get props => [response];
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message);

  @override
  List<Object> get props => [message];
}

// Authenticated State

class Authenticated extends RegisterState {
  final String token;

  const Authenticated(this.token);

  @override
  List<Object> get props => [token];
}

// Unauthenticated State

class Unauthenticated extends RegisterState {
  final String message;

  const Unauthenticated({required this.message});
  @override
  List<Object> get props => [message];
}
