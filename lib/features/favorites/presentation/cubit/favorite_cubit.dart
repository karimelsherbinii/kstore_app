import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/features/favorites/domain/usecases/add_to_favorite.dart';
import 'package:kstore/features/products/domain/entities/product.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../orders/domain/entities/order.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/delete_favorite.dart';
import '../../domain/usecases/get_favorites.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoritesRepository repository;
  final AddFavorite addFavoriteUseCase;
  final GetFavorites getFavoritesUseCase;
  final DeleteFavorite deleteFavoriteUseCase;


  FavoriteCubit({
    required this.repository,
    required this.addFavoriteUseCase,
    required this.getFavoritesUseCase,
    required this.deleteFavoriteUseCase,
  }) : super(FavoriteInitial());

  bool isFavorite = false;
  List<Product> favoriteProducts = [];
  List<Order> favoriteOrders = [];

  Future<void> getFavoriteProducts() async {
    emit(GetFavoriteProductsLoadingState());
    final result =
        await getFavoritesUseCase(const GetFavoritesPrams(type: 'product'));
    result.fold(
        (failure) =>
            emit(GetFavoriteProductsErrorState(message: failure.message!)),
        (response) {
      favoriteProducts = response.data;
      log (favoriteProducts.toString(), name: 'favoriteProducts');
      emit(GetFavoriteProductsLoadedState(favorites: response.data));
    });
  }

  Future<void> getFavoriteOrders() async {
    emit(GetFavoriteOrdersLoadingState());
    final result =
        await getFavoritesUseCase(const GetFavoritesPrams(type: 'order'));
    result.fold(
        (failure) =>
            emit(GetFavoriteOrdersErrorState(message: failure.message!)),
        (response) {
      favoriteOrders = response.data;
      emit(GetFavoriteOrdersLoadedState(favorites: response.data));
    });
  }

  Future<void> addToFavorite({
    required int productId,
    required String type,
  }) async {
    emit(AddFavoriteLoadingState());
    final result = await addFavoriteUseCase(
        AddToFavoriteParams(productId: productId, type: type));
    result.fold(
        (failure) => emit(AddFavoriteErrorState(message: failure.message!)),
        (response) {
      toggleFavorite();
      emit(AddFavoriteLoadedState(message: response.message!));
    });
  }

  Future<void> deleteFavorite({
    required int productId,
    required String type,
  }) async {
    emit(DeleteFavoriteLoadingState());
    final result = await deleteFavoriteUseCase(
        DeleteFavoriteParams(productId: productId, type: type));
    result.fold(
      (failure) => emit(DeleteFavoriteErrorState(message: failure.message!)),
      (response) {
        toggleFavorite();
        emit(DeleteFavoriteLoadedState(message: response.message!));
      },
    );
  }

  toggleFavorite() {
    isFavorite = !isFavorite;
    emit(ToggleFavoriteState());
  }

  bool getIsFavoriteProduct(int productId) {
    return favoriteProducts.any((element) {
      log(element.id.toString(), name: 'isFavotriteProduct');
      isFavorite = element.id == productId;
      return element.id == productId;
    });
  }

  bool getIsFavoriteOrder(int orderId) {
    return favoriteOrders.any((element) {
      log(element.id.toString(), name: 'isFavotriteOrder');
      isFavorite = element.id == orderId;
      return element.id == orderId;
    });
  }
}
