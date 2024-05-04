import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/orders_repository.dart';

class AddOrder extends UseCase<BaseResponse, AddOrderParams> {
  final OrdersRepository repository;

  AddOrder({
    required this.repository,
  });

  @override
  Future<Either<Failure, BaseResponse>> call(AddOrderParams params) async {
    return await repository.addOrder(
      paymentProviderId: params.paymentProviderId,
      branchId: params.branchId,
      delivery: params.delivery,
      addressId: params.addressId,
      promoCode: params.promoCode,
      phone: params.phone,
    );
  }
}

class AddOrderParams extends Equatable {
  final int paymentProviderId;
  final int branchId;
  final int delivery;
  final int addressId;
  final String? promoCode;
  final String? phone;

  const AddOrderParams({
    required this.paymentProviderId,
    required this.branchId,
    required this.delivery,
    required this.addressId,
    this.promoCode,
    this.phone,
  });

  @override
  List<Object> get props => [
        paymentProviderId,
        branchId,
        delivery,
        addressId,
        promoCode!,
        phone!,
      ];
}
