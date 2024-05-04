import 'package:kstore/features/products/domain/entities/color.dart';

import 'color_size_model.dart';

class ProductColorModel extends ProductColor {
  const ProductColorModel({
    super.id,
    super.color,
    super.images,
    super.sizes,
  });

  factory ProductColorModel.fromJson(Map<String, dynamic> json) =>
      ProductColorModel(
        id: json['id'],
        color: json['color'],
      images: json['images'] != null ? (json['images'] as List<dynamic>) : [],
        sizes: json['sizes'] != null
          ? (json['sizes'] as List)
              .map((e) => ColorSizeModel.fromJson(e))
              .toList()
          : [],
      );
}
