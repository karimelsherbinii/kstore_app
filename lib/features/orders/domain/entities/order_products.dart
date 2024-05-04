import 'package:equatable/equatable.dart';
import 'package:kstore/features/orders/domain/entities/order_product.dart';

class OrderProducts extends Equatable {
  final OrderProduct? orderProduct;
  final int? quantity;

  const OrderProducts({
     this.orderProduct,
     this.quantity,
  });

  @override
  List<Object?> get props => [
    orderProduct,
    quantity,
  ];
}