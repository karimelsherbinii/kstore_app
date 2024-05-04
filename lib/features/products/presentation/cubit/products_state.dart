part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class GetProductsLoadingState extends ProductsState {
  final bool isFirstFetch;
  const GetProductsLoadingState({this.isFirstFetch = false});
  @override
  List<Object> get props => [isFirstFetch];
}

class GetProductsLoadedState extends ProductsState {
  final List<Product> products;
  const GetProductsLoadedState(this.products);
  @override
  List<Object> get props => [products];
}

class GetProductsErrorState extends ProductsState {
  final String message;
  const GetProductsErrorState(this.message);
  @override
  List<Object> get props => [message];
}

//product
class GetProductLoadingState extends ProductsState {}

class GetProductLoadedState extends ProductsState {
  final Product product;
  const GetProductLoadedState(this.product);
  @override
  List<Object> get props => [product];
}

class GetProductErrorState extends ProductsState {
  final String message;
  const GetProductErrorState(this.message);
  @override
  List<Object> get props => [message];
}


class ProductQuantityChangedState extends ProductsState{}

class TotalPriceChangedState extends ProductsState{

  @override
  List<Object> get props => [];
}

class AddSubProductPriceToTotalState extends ProductsState{
  @override
  List<Object> get props => [];
}

class RemoveSubProductPriceFromTotalState extends ProductsState{
  @override
  List<Object> get props => [];
}

class SubProductsChangedState extends ProductsState{
  @override
  List<Object> get props => [];
}

class SubProductsQuantitiesChangedState extends ProductsState{
  @override
  List<Object> get props => [];
}