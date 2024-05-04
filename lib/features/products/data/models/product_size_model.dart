import 'package:kstore/features/products/domain/entities/size.dart';

class ProductSizeModel extends ProductSize {
  const ProductSizeModel({super.id, super.name});

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) =>
      ProductSizeModel(
        id: json['id'],
        name: json['name'] ,
      );
}
