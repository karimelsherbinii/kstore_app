import 'package:kstore/features/orders/data/models/order_product_model.dart';
import 'package:kstore/features/orders/data/models/status_model.dart';
import 'package:kstore/features/profile/data/models/user_model.dart';

import '../../domain/entities/order.dart';
import '../../../profile/data/models/address_model.dart';
import 'order_products_model.dart';

class OrderModel extends Order {
  const OrderModel(
      {required super.id,
      required super.price,
      required super.total,
      required super.paymentMethod,
      required super.promocode,
      required super.branch,
      required super.delivery,
      required super.user,
      required super.status,
      required super.createdAt,
      required super.products,
      required super.statuses,
      required super.address});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      price: json['price'],
      total: json['total'],
      paymentMethod: json['payment_method'],
      promocode: json['promocode'],
      branch: json['branch'],
      delivery: json['delivery'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      status: json['status'],
      createdAt: json['created_at'],
      products: json['products']
          .map<OrderProductsModel>(
              (product) => OrderProductsModel.fromJson(product))
          .toList(),
      statuses: json['statuses']
          .map<StatusModel>((status) => StatusModel.fromJson(status))
          .toList(),
      address: AddressModel.fromJson(json['address']),
    );
  }
}
