part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileGenderSelected extends ProfileState {
  @override
  List<Object> get props => [];
}

// final GetUserAddress getUserAddressUseCase;
// final UpdateUseAddress updateUseAddressUseCase;
// final AddUseAddress addUseAddressUseCase;
// final DeleteUseAddress deleteUseAddressUseCase;
// final GetUserInfo getUserInfoUseCase;
// final UpdateUserInfo updateUserInfoUseCase;
class GetUserAddressLoadingState extends ProfileState {}

class GetUserAddressLoadedState extends ProfileState {
  final List<Address> addresses;
  const GetUserAddressLoadedState({required this.addresses});
  @override
  List<Object> get props => [addresses];
}

class GetUserAddressErrorState extends ProfileState {
  final String message;
  const GetUserAddressErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class UpdateUseAddressLoadingState extends ProfileState {}

class UpdateUseAddressLoadedState extends ProfileState {
  final String message;
  const UpdateUseAddressLoadedState({required this.message});
  @override
  List<Object> get props => [message];
}

class UpdateUseAddressErrorState extends ProfileState {
  final String message;
  const UpdateUseAddressErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class AddUseAddressLoadingState extends ProfileState {}

class AddUseAddressLoadedState extends ProfileState {
  final Address address;
  const AddUseAddressLoadedState({required this.address});
  @override
  List<Object> get props => [address];
}

class AddUseAddressErrorState extends ProfileState {
  final String message;
  const AddUseAddressErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class DeleteUseAddressLoadingState extends ProfileState {}

class DeleteUseAddressLoadedState extends ProfileState {
  final String message;
  const DeleteUseAddressLoadedState({required this.message});
  @override
  List<Object> get props => [message];
}

class DeleteUseAddressErrorState extends ProfileState {
  final String message;
  const DeleteUseAddressErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class GetUserInfoLoadingState extends ProfileState {}

class GetUserInfoLoadedState extends ProfileState {
  final User user;
  const GetUserInfoLoadedState({required this.user});
  @override
  List<Object> get props => [user];
}

class GetUserInfoErrorState extends ProfileState {
  final String message;
  const GetUserInfoErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class UpdateUserInfoLoadingState extends ProfileState {}

class UpdateUserInfoLoadedState extends ProfileState {
  const UpdateUserInfoLoadedState();
  @override
  List<Object> get props => [];
}

class UpdateUserInfoErrorState extends ProfileState {
  final String message;
  const UpdateUserInfoErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
