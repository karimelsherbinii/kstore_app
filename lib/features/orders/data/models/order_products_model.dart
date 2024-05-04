import '../../domain/entities/order_products.dart';
import 'order_product_model.dart';

class OrderProductsModel extends OrderProducts {
  const OrderProductsModel({
     super.orderProduct,
     super.quantity,
  });

  factory OrderProductsModel.fromJson(Map<String, dynamic> json) {
    return OrderProductsModel(
      orderProduct: OrderProductModel.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}