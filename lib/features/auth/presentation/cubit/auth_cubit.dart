
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/responses/base_response.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool signInIsSelected = true;
  bool signUpIsSelected = false;

  selectSignInPage() {
    emit(SelectSignUpState());
    signUpIsSelected = true;
    signInIsSelected = false;
    emit(SelectSignInState());
  }

  selectSignUpPage() {
    emit(SelectSignInState());
    signInIsSelected = true;
    signUpIsSelected = false;
    emit(SelectSignUpState());
  }
}
