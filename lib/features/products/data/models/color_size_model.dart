import 'package:kstore/features/products/domain/entities/color.dart';

import '../../domain/entities/color_size.dart';


class ColorSizeModel extends ColorSize {
  const ColorSizeModel({
    super.id,
    super.size,
    super.price,
    super.discount,
    super.quantity,
    super.productId,
  });

  factory ColorSizeModel.fromJson(Map<String, dynamic> json) => ColorSizeModel(
        id: json['id'],
        size: json['size'],
        price: json['price'],
        discount: json['discount'],
        quantity: json['quantity'],
        productId: json['productId'],
      );
}
