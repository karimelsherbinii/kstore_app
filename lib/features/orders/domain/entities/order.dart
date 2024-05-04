import 'package:equatable/equatable.dart';
import 'package:kstore/features/orders/domain/entities/status.dart';
import 'package:kstore/features/profile/domain/entities/user.dart';

import '../../../profile/domain/entities/address.dart';
import 'order_products.dart';

class Order extends Equatable {
  final int id;
  final int price;
  final int total;
  final String paymentMethod;
  final String? promocode;
  final String branch;
  final String delivery;
  final User? user;
  final int? status;
  final String createdAt;
  final List<OrderProducts> products;
  final List<Status> statuses;
  final Address address;

  const Order({
    required this.id,
    required this.price,
    required this.total,
    required this.paymentMethod,
    required this.promocode,
    required this.branch,
    required this.delivery,
    required this.user,
     this.status,
    required this.createdAt,
    required this.products,
    required this.statuses,
    required this.address,
  });

  @override
  List<Object?> get props => [
        id,
        price,
        total,
        paymentMethod,
        promocode,
        branch,
        delivery,
        user,
        status,
        createdAt,
        products,
        statuses,
        address,
      ];
}
