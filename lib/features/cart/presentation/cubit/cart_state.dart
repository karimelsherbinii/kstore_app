part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  final int quantity;

  const CartState({this.quantity = 0});

  @override
  List<Object> get props => [
        quantity,
      ];
}

class CartInitial extends CartState {}

class CartIncrement extends CartState {
  int quantity;

  CartIncrement({this.quantity = 0});

  @override
  List<Object> get props => [quantity];
}

class CartDecrement extends CartState {
  int quantity;

  CartDecrement({this.quantity = 0});

  @override
  List<Object> get props => [quantity];
}

class AttachProductCartLoadingState extends CartState {
  @override
  List<Object> get props => [];
}

class AttachProductCartLoadedState extends CartState {
  // final List<OrderProduct> products;
  // const AttachProductCartLoadedState({required this.products});
  @override
  List<Object> get props => [];
}

class AttachProductCartErrorState extends CartState {
  final String message;

  const AttachProductCartErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class GetCartProductsLoadingState extends CartState {
  @override
  List<Object> get props => [];
}

class GetCartProductsLoadedState extends CartState {
  final List<OrderProducts> products;
  const GetCartProductsLoadedState({required this.products});
  @override
  List<Object> get props => [products];
}

class GetCartProductsErrorState extends CartState {
  final String message;

  const GetCartProductsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class CartProductQuantityChangedState extends CartState {

}

class TotalPriceChangedState extends CartState {
  @override
  List<Object> get props => [];
}

class ProductChangedState extends CartState {
  @override
  List<Object> get props => [];
}


class DiscountPriceOfCartProdctsChangedState extends CartState {
  @override
  List<Object> get props => [];
}

class CartProductsTotalPriceChangedState extends CartState {
  @override
  List<Object> get props => [];
}

class CartProductsQuantityChangedState extends CartState {
  @override
  List<Object> get props => [];
}

class CartResetState extends CartState {
  @override
  List<Object> get props => [];
}

class DiscountedPriceOfCartProdctsChangedState extends CartState {
  @override
  List<Object> get props => [];
}

class AddSubProductPriceToTotalState extends CartState {
  @override
  List<Object> get props => [];
}
class RemoveSubProductPriceFromTotalState extends CartState {
  @override
  List<Object> get props => [];
}

class AttachSubProductToCartLoadingState  extends CartState {
  @override
  List<Object> get props => [];
}
class AttachSubProductToCartErrorState extends CartState {
  final String message;

  const AttachSubProductToCartErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
class AttachSubProductToCartLoadedState extends CartState {
  final int index;

  const AttachSubProductToCartLoadedState({required this.index});

  @override
  List<Object> get props => [index];
}

class ProductsIdiesHaveExstraItemsSavedState extends CartState {
  @override
  List<Object> get props => [];
}

class GetSubProductsFromProductByIdState extends CartState{
    @override
  List<Object> get props => [];
}