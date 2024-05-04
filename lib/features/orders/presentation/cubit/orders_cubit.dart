import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:kstore/features/orders/domain/entities/order.dart'
    as orderEntity;
import 'package:kstore/features/orders/domain/usecases/cancel_order.dart';
import 'package:kstore/features/orders/domain/usecases/reorder.dart';

import '../../../../core/api/responses/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/add_order.dart';
import '../../domain/usecases/get_order.dart';
import '../../domain/usecases/get_orders.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final AddOrder addOrderUseCase;
  final GetOrders getOrdersUseCase;
  final GetOrder getOrderUseCase;
  final ReOrder reOrderUseCase;
  final CancelOrder cancelOrderUseCase;

  OrdersCubit({
    required this.addOrderUseCase,
    required this.getOrdersUseCase,
    required this.getOrderUseCase,
    required this.reOrderUseCase,
    required this.cancelOrderUseCase,
  }) : super(OrdersInitial());

// checkPromoCode(String promoCode) async {
//     emit(CheckPromoCodeLoadingState());
//     final response = await checkPromoCodeUseCase(CheckPromoCodeParams(promoCode: promoCode));
//     response.fold(
//       (failure) => emit(CheckPromoCodeErrorState(message: failure.message!)),
//       (response) {
//         if (response.statusCode == 200) {
//           emit(CheckPromoCodeSuccessState(message: response.message!));
//         } else {
//           emit(CheckPromoCodeErrorState(message: response.message!));
//         }
//       },
//     );
//   }
  Future<void> addOrder({
    required int paymentProviderId,
    String? promoCode,
    required int branchId,
    int? delivery,
    required int addressId,
    String? phone,
  }) async {
    emit(AddOrderLoadingState());
    final response = await addOrderUseCase(
      AddOrderParams(
        paymentProviderId: paymentProviderId,
        promoCode: promoCode,
        branchId: branchId,
        delivery: 0,
        addressId: addressId,
        phone: phone,
      ),
    );
    response
        .fold((failure) => emit(AddOrderErrorState(message: failure.message!)),
            (response) {
      if (response.statusCode == 201) {
        if (response.data != null) {
          log('orderr: ${response.data}');
          order = response.data;
          emit(AddOrderSuccessState(
              message: response.message!, order: response.data));
        } else {
          emit(AddOrderErrorState(message: '${response.message!} But no data'));
        }
      } else {
        emit(AddOrderErrorState(message: response.message!));
      }
    });
  }

  List<orderEntity.Order> orders = [];
  List<orderEntity.Order> recentOrders = [];
  int totalOrders = 0;
  bool loadMore = false;
  int pageNo = 1, totalPages = 1;
  Future<void> getOrders({
    int? perPage,
    int? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (state is GetOrdersLoadingState) return;
    emit(GetOrdersLoadingState(isFirstFetch: pageNo == 1));
    Either<Failure, BaseResponse> response =
        await getOrdersUseCase(GetOrdersParams(
      pageNo: pageNo,
      perPage: perPage,
      status: status,
      sortBy: sortBy,
      sortOrder: sortOrder,
    ));
    response.fold(
      (failure) => emit(GetOrdersErrorState(message: failure.message!)),
      (response) {
        orders.addAll(response.data);
        log('orders length: ${orders.length}');
        totalPages = response.lastPage!;
        totalOrders = response.total!;
        pageNo++;
        emit(GetOrdersLoadedState(orders: response.data));
      },
    );
  }

  Future<void> getRecentOrders({
    int? perPage,
    int status = 0,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (state is GetRecentOrdersLoadingState) return;
    emit(GetRecentOrdersLoadingState());
    Either<Failure, BaseResponse> response =
        await getOrdersUseCase(GetOrdersParams(
      pageNo: pageNo,
      perPage: perPage,
      status: status,
      sortBy: sortBy,
    ));
    response.fold(
      (failure) => emit(GetRecentOrdersErrorState(message: failure.message!)),
      (response) {
        recentOrders.clear();
        recentOrders = response.data;
        log('recentOrders length: ${recentOrders.length}');
        emit(GetRecentOrdersLoadedState(orders: response.data));
      },
    );
  }

  // clear data
  void clearData() {
    if (orders.isNotEmpty) {
      orders.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }

  orderEntity.Order? order;
  Future<void> getOrder(int id) async {
    emit(GetOrderLoadingState());
    final response = await getOrderUseCase(GetOrderParams(id: id));
    response.fold(
      (failure) => emit(GetOrderErrorState(message: failure.message!)),
      (order) {
        this.order = order;
        emit(GetOrderLoadedState(order: order));
      },
    );
  }

  Future<void> reOrder(int orderId) async {
    emit(ReOrderLoadingState());
    final response = await reOrderUseCase(ReOrderParams(order: orderId));
    response.fold(
      (failure) => emit(ReOrderErrorState(message: failure.message!)),
      (response) {
        if (response.statusCode == 201) {
          emit(ReOrderSuccessState(message: response.message!));
        } else {
          emit(ReOrderErrorState(message: response.message!));
        }
      },
    );
  }

  Future<void> cancelOrder(int orderId) async {
    emit(CancelOrderLoadingState());
    final response =
        await cancelOrderUseCase(CancelOrderParams(orderId: orderId));
    response.fold(
      (failure) => emit(CancelOrderErrorState(message: failure.message!)),
      (response) {
        if (response.statusCode == 200) {
          emit(CancelOrderSuccessState(message: response.message!));
        } else {
          emit(CancelOrderErrorState(message: response.message!));
        }
      },
    );
  }
}
