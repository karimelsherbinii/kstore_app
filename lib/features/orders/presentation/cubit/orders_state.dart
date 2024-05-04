import 'package:equatable/equatable.dart';
import 'package:kstore/features/orders/domain/entities/order.dart';

import '../../domain/entities/order.dart' as order;

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

//? get orders

class GetOrdersLoadingState extends OrdersState {
  final bool isFirstFetch;

  const GetOrdersLoadingState({this.isFirstFetch = false});

  @override
  List<Object> get props => [isFirstFetch];
}

class GetOrdersLoadedState extends OrdersState {
  final List<order.Order> orders;

  const GetOrdersLoadedState({required this.orders});

  @override
  List<Object> get props => [orders];
}

class GetOrdersErrorState extends OrdersState {
  final String message;

  const GetOrdersErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

//? add order

class AddOrderLoadingState extends OrdersState {}

class AddOrderSuccessState extends OrdersState {
  final String message;
  final Order order;

  const AddOrderSuccessState({required this.message, required this.order});

  @override
  List<Object> get props => [message, order];
}

class AddOrderErrorState extends OrdersState {
  final String message;

  const AddOrderErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

//? get order

class GetOrderLoadingState extends OrdersState {}

class GetOrderLoadedState extends OrdersState {
  final Order order;

  const GetOrderLoadedState({required this.order});

  @override
  List<Object> get props => [order];
}

class GetOrderErrorState extends OrdersState {
  final String message;

  const GetOrderErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

//? get recent orders

class GetRecentOrdersLoadingState extends OrdersState {}

class GetRecentOrdersLoadedState extends OrdersState {
  final List<order.Order> orders;

  const GetRecentOrdersLoadedState({required this.orders});

  @override
  List<Object> get props => [orders];
}

class GetRecentOrdersErrorState extends OrdersState {
  final String message;
  const GetRecentOrdersErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

//? reorder

class ReOrderLoadingState extends OrdersState {}

class ReOrderSuccessState extends OrdersState {
  final String message;

  const ReOrderSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class ReOrderErrorState extends OrdersState {
  final String message;

  const ReOrderErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

//? cancel order

class CancelOrderLoadingState extends OrdersState {}

class CancelOrderSuccessState extends OrdersState {
  final String message;

  const CancelOrderSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class CancelOrderErrorState extends OrdersState {
  final String message;

  const CancelOrderErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
