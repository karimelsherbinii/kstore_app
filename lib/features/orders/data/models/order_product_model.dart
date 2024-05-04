import 'package:kstore/features/cetegories/data/models/category_model.dart';
import 'package:kstore/features/products/data/models/product_model.dart';

import '../../domain/entities/order_product.dart';

class OrderProductModel extends OrderProduct {
  const OrderProductModel({
    super.id,
    super.size,
    super.price,
    super.discount,
    super.quantity,
    super.productId,
    super.name,
    super.description,
    super.rate,
    super.enabled,
    super.createdAt,
    super.images,
    super.categories,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'],
      size: json['size'],
      price: json['price'],
      discount: json['discount'],
      quantity: json['quantity'],
      productId: json['product_id'],
      name: json['name'],
      description: json['description'],
      rate: json['rate'],
      enabled: json['enabled'],
      createdAt: json['created_at'],
      images: json['images'] != null ? (json['images'] as List<dynamic>) : [],
      categories: json['category'] != null
          ? (json['category'] as List)
          .map((e) => CategoryModel.formJson(e))
          .toList()
          : [],
    );
  }
}
