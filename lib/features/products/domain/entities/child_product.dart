import 'package:equatable/equatable.dart';
import 'package:kstore/features/cetegories/domain/entities/category.dart';
import 'package:kstore/features/products/domain/entities/color.dart';

class ChildProduct extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final int? rate;
  final int? enabled;
  final String? createdAt;
  final List<ProductColor>? colors;
  final List<dynamic>? images;
  final List<Category>? categories;
  final int? price;
  final int? discount;
  final int? quantity;


  const ChildProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.rate,
    required this.enabled,
    required this.createdAt,
    required this.colors,
    required this.images,
    required this.categories,
    required this.price,
    required this.discount,
    required this.quantity,

          
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        rate,
        enabled,
        createdAt,
        colors,
        images,
        categories,
        price,
        discount,
        quantity,
      ];
}
