import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/features/profile/domain/entities/address.dart';
import 'package:kstore/features/profile/domain/entities/user.dart';
import 'package:kstore/features/profile/domain/usecases/add_user_address.dart';
import 'package:kstore/features/profile/domain/usecases/delete_user_address.dart';
import 'package:kstore/features/profile/domain/usecases/get_user_address.dart';
import 'package:kstore/features/profile/domain/usecases/get_user_info.dart';
import 'package:kstore/features/profile/domain/usecases/updata_user_address.dart';
import 'package:kstore/features/profile/domain/usecases/update_user_info.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserAddress getUserAddressUseCase;
  final UpdateUseAddress updateUseAddressUseCase;
  final AddUseAddress addUseAddressUseCase;
  final DeleteUseAddress deleteUseAddressUseCase;
  final GetUserInfo getUserInfoUseCase;
  final UpdateUserInfo updateUserInfoUseCase;

  ProfileCubit({
    required this.getUserAddressUseCase,
    required this.updateUseAddressUseCase,
    required this.addUseAddressUseCase,
    required this.deleteUseAddressUseCase,
    required this.getUserInfoUseCase,
    required this.updateUserInfoUseCase,
  }) : super(ProfileInitial());

  // genders
  List<String> genders = [
    'male',
    'female',
  ];

  String? selectedGender;
  // String getSelectedGender() {
  //   if (user!.gender != null){
  //     return user!.gender!;
  //   }else{
  //     return selectedGender;
  //   }
  // }

  // selectGender(String value) {
  //   selectedGender == value;
  //   log('selectedGender: $selectedGender');
  //   emit(ProfileGenderSelected());
  // }

  // addresses
  List<Address> addresses = [];

  Future<void> getUserAddress() async {
    emit(GetUserAddressLoadingState());
    final result = await getUserAddressUseCase(NoParams());
    result.fold(
      (failure) => emit(GetUserAddressErrorState(message: failure.message!)),
      (response) {
        _clearAddresses();
        addresses.addAll(response.data);
        emit(GetUserAddressLoadedState(addresses: response.data));
      },
    );
  }

  Future<void> updateUserAddress({
    required String street,
    required String city,
    required String state,
    required String zip,
    required String country,
  }) async {
    emit(UpdateUseAddressLoadingState());
    final result = await updateUseAddressUseCase(UpdateUseAddressParams(
      street: street,
      city: city,
      state: state,
      zip: zip,
      country: country,
    ));
    result.fold(
      (failure) => emit(UpdateUseAddressErrorState(message: failure.message!)),
      (response) {
        emit(UpdateUseAddressLoadedState(message: response.message!));
      },
    );
  }

  Future<void> addUserAddress({
    required String street,
    required String city,
    required String state,
    required String zip,
    required String country,
  }) async {
    emit(AddUseAddressLoadingState());
    final result = await addUseAddressUseCase(AddUseAddressParams(
      street: street,
      city: city,
      state: state,
      zip: zip,
      country: country,
    ));
    result.fold(
      (failure) => emit(AddUseAddressErrorState(message: failure.message!)),
      (response) {
        emit(AddUseAddressLoadedState(address: response.data!));
      },
    );
  }

  Future<void> deleteUserAddress({
    required int addressId,
  }) async {
    emit(DeleteUseAddressLoadingState());
    final result = await deleteUseAddressUseCase(DeleteUseAddressParams(
      id: addressId,
    ));
    result.fold(
      (failure) => emit(DeleteUseAddressErrorState(message: failure.message!)),
      (response) {
        emit(DeleteUseAddressLoadedState(message: response.message!));
      },
    );
  }

  // user info
  User? user;

  Future<void> getUserInfo() async {
    emit(GetUserInfoLoadingState());
    final result = await getUserInfoUseCase(NoParams());
    result.fold(
      (failure) => emit(GetUserInfoErrorState(message: failure.message!)),
      (response) {
      
        user = response.data;
        emit(GetUserInfoLoadedState(user: response.data));
      },
    );
  }

  Future<void> updateUserInfo({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required String birthDate,
    required String phone,
    required String gender,
    File? profileImage,
  }) async {
    emit(UpdateUserInfoLoadingState());
    final result = await updateUserInfoUseCase(UpdateUserInfoParams(
      firstName: firstName,
      lastName: lastName,
      userName: userName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      birthDate: birthDate,
      phone: phone,
      gender: gender,
      profileImage: profileImage,
    ));
    result.fold(
      (failure) => emit(UpdateUserInfoErrorState(message: failure.message!)),
      (response) {
        if (response.statusCode == 200) {
          emit(UpdateUserInfoLoadedState());
        } else {
          emit(UpdateUserInfoErrorState(message: response.message!));
        }
      },
    );
  }

  _clearAddresses() {
    addresses.clear();
  }
}
