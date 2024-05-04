import 'package:equatable/equatable.dart';
import 'package:kstore/features/products/domain/entities/product.dart';

import '../../../cetegories/domain/entities/category.dart';

class OrderProduct extends Equatable {
  final int? id;
  final String? size;
  final int? price;
  final int? discount;
  final int? quantity;
  final int? productId;
  final String? name;
  final String? description;
  final int? rate;
  final int? enabled;
  final String? createdAt;
  final List<dynamic>? images;
  final List<Category>? categories;

  const OrderProduct({
    this.id,
    this.size,
    this.price,
    this.discount,
    this.quantity,
    this.productId,
    this.name,
    this.description,
    this.rate,
    this.enabled,
    this.createdAt,
    this.images,
    this.categories,
  });

  @override
  List<Object?> get props => [
        id,
        size,
        price,
        discount,
        quantity,
        productId,
        name,
        description,
        rate,
        enabled,
        createdAt,
        images,
        categories,
      ];
}
