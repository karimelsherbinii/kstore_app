import 'package:kstore/features/cetegories/data/models/category_model.dart';
import 'package:kstore/features/products/data/models/product_color_model.dart';
import 'package:kstore/features/products/domain/entities/child_product.dart';

class ChildProductModel extends ChildProduct {
  const ChildProductModel({
    super.id,
    super.name,
    super.description,
    super.rate,
    super.enabled,
    super.createdAt,
    super.colors,
    super.images,
    super.categories,
    super.price,
    super.discount,
    super.quantity,
  });

  factory ChildProductModel.fromJson(Map<String, dynamic> json) {
    return ChildProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      rate: json['rate'],
      enabled: json['enabled'],
      createdAt: json['created_at'],
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
      price: json['price'],
      discount: json['discount'],
      quantity: json['quantity'],
    );
  }
}
