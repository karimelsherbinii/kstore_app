import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/core/api/status_code.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/core/utils/app_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/features/auth/domain/usecases/get_saved_login_credentials.dart';
import 'package:kstore/features/auth/domain/usecases/login.dart';
import 'package:kstore/features/auth/domain/usecases/logout_locally.dart';
import 'package:kstore/features/auth/domain/usecases/save_login_credentials.dart';
import 'package:kstore/features/profile/data/models/user_model.dart';
import 'package:kstore/features/profile/domain/entities/user.dart';

import '../auth_cubit.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Login loginUseCase;

  final SaveLoginCredentials saveLoginCredentialsUseCase;
  final GetLoginCredentials getLoginCredentials;
  final LogoutLocally logoutLocallyUseCase;
  LoginCubit({
    required this.loginUseCase,
    required this.saveLoginCredentialsUseCase,
    required this.getLoginCredentials,
    required this.logoutLocallyUseCase,
  }) : super(LoginInitial());

  UserModel? authenticatedUser;

  void getSavedLoginCredentials() async {
    final response = await getLoginCredentials.call(NoParams());
    response.fold((failure) => debugPrint(AppStrings.cacheFailure), (user) {
      if (user != null) {
        authenticatedUser = user;
        log('${authenticatedUser!.email}', name: 'authenticatedUser email');
        emit(AuthenticatedState(authenticatedUser: authenticatedUser!));
      } else {
        log('unauthenticated', name: 'authenticatedUser email');
        emit(UnAuthenticatedState());
      }
    });
  }

  Future<void> login(
      {required String email,
      required String password,
      required bool credentialsIsSaved}) async {
    emit(LoginLoadingState());
    final response =
        await loginUseCase(LoginParams(email: email, password: password));
    response.fold((failure) => emit(LoginErrorState(message: failure.message!)),
        (response) {
      if (response.statusCode == StatusCode.ok) {
        if (credentialsIsSaved) {
          log('${response.data!}', name: 'credentialsIsSaved');
          log('$credentialsIsSaved', name: 'credentialsIsSaved bool');
          authenticatedUser = response.data!;
          CacheHelper.saveData(
              key: AppStrings.token, value: authenticatedUser!.token!);
          saveLoginCredentialsUseCase(
              SaveLoginCredentialsParams(user: response.data!));
        }
        log('$credentialsIsSaved', name: 'credentialsIsSaved bool');
        emit(const LoginSuccessState());
      } else {
        log('${response.message!}', name: 'login error');
        emit(LoginErrorState(message: response.message!));
      }
    });
  }

  Future<void> logoutLocally({required BuildContext context}) async {
    emit(LogoutLocallyLoadingState());
    final response = await logoutLocallyUseCase(NoParams());
    response.fold(
        (failure) => emit(LogoutLocallyErrorState(message: failure.message!)),
        (success) {
      if (success) {
        log('$success', name: 'logoutLocally');
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.authScreen, (route) => false);
        BlocProvider.of<AuthCubit>(context).selectSignInPage();
        emit(LogoutLocallySuccessState(
            message: AppLocalizations.of(context)!
                .translate('logout_successfully')!));
      } else {
        log('$success', name: 'logoutLocally');
        Constants.showError(
            context, AppLocalizations.of(context)!.translate('logout_failed')!);
        emit(LogoutLocallyErrorState(
            message:
                AppLocalizations.of(context)!.translate('logout_failed')!));
      }
    });
  }
}
