import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';

import '../../../../../core/api/status_code.dart';
import '../../../domain/usecases/register.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final Register registerUseCase;

  RegisterCubit({required this.registerUseCase}) : super(RegisterInitial());

 
  Future<void> register({
    required String userName,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoadingState());

    Either<Failure, BaseResponse> result = await registerUseCase(
      RegisterParams(
        userName: userName,
        email: email,
        password: password,
        confirmPassword: password,
      ),
    );

    result.fold((failure) {
      emit(RegisterError(failure.message!));
      return false;
    }, (response) {
      if (response.statusCode == StatusCode.created) {
        emit(RegisterSuccessState(response));
        emit(Authenticated(response.token!));
        log('Success: $result', name: 'AuthCubit');
      } else {
        emit(RegisterError(response.message!));
        emit(Unauthenticated(message: response.message!));
        log('Fail: $result', name: 'AuthCubit');
      }
    });
    log('Out of register', name: 'AuthCubit');
  }
}
