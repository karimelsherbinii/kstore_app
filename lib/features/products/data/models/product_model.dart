import 'package:kstore/features/products/data/models/product_color_model.dart';
import 'package:kstore/features/products/domain/entities/product.dart';

import '../../../cetegories/data/models/category_model.dart';
import 'child_product_model.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id,
    super.name,
    super.description,
    super.rate,
    super.enabled,
    super.createdAt,
    super.price,
    super.quantity,
    super.discount,
    super.colors,
    required super.images,
    super.categories,
    super.childrens,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      rate: json['rate'],
      enabled: json['enabled'],
      createdAt: json['created_at'],
      price: json['price'],
      quantity: json['quantity'],
      discount: json['discount'],
      colors: json['colors'] != null
          ? (json['colors'] as List)
              .map((e) => ProductColorModel.fromJson(e))
              .toList()
          : [],
      images: json['images'] != null ? (json['images'] as List<dynamic>) : [],
      categories: json['category'] != null
          ? (json['category'] as List)
              .map((e) => CategoryModel.formJson(e))
              .toList()
          : [],
      childrens: json['child'] != null
          ? (json['child'] as List)
              .map((e) => ChildProductModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
