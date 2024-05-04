import 'package:equatable/equatable.dart';
import 'package:kstore/features/cetegories/domain/entities/category.dart';
import 'package:kstore/features/products/domain/entities/color.dart';

import 'child_product.dart';

class Product extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final int? rate;
  final int? enabled;
  final String? createdAt;
  final int? price;
  final int? quantity;
  final int? discount;
  final List<ProductColor>? colors;
  final List<dynamic> images;
  final List<Category>? categories;
  final List<ChildProduct>? childrens;

  const Product({
    this.id,
    this.name,
    this.description,
    this.rate,
    this.enabled,
    this.createdAt,
    this.price,
    this.quantity,
    this.discount,
    this.colors,
    required this.images,
    this.categories,
    this.childrens,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        rate,
        enabled,
        createdAt,
        price,
        quantity,
        discount,
        colors,
        images,
        categories,
        childrens,
      ];
}
