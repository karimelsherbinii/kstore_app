part of 'favorite_cubit.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class GetFavoriteProductsLoadingState extends FavoriteState {}

class GetFavoriteProductsLoadedState extends FavoriteState {
  final List<Product> favorites;
  const GetFavoriteProductsLoadedState({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

class GetFavoriteProductsErrorState extends FavoriteState {
  final String message;

  const GetFavoriteProductsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class GetFavoriteOrdersLoadingState extends FavoriteState {}

class GetFavoriteOrdersLoadedState extends FavoriteState {
  final List<Order> favorites;
  const GetFavoriteOrdersLoadedState({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

class GetFavoriteOrdersErrorState extends FavoriteState {
  final String message;

  const GetFavoriteOrdersErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class AddFavoriteLoadingState extends FavoriteState {}

class AddFavoriteLoadedState extends FavoriteState {
  final String message;

  const AddFavoriteLoadedState({required this.message});

  @override
  List<Object> get props => [message];
}

class AddFavoriteErrorState extends FavoriteState {
  final String message;

  const AddFavoriteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class DeleteFavoriteLoadingState extends FavoriteState {}

class DeleteFavoriteLoadedState extends FavoriteState {
  final String message;

  const DeleteFavoriteLoadedState({required this.message});

  @override
  List<Object> get props => [message];
}

class DeleteFavoriteErrorState extends FavoriteState {
  final String message;

  const DeleteFavoriteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class ToggleFavoriteState extends FavoriteState{}