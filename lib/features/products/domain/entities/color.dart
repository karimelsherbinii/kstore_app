import 'package:equatable/equatable.dart';
import 'package:kstore/features/products/domain/entities/color_size.dart';

class ProductColor extends Equatable {
  final int? id;
  final String? color;
  final List<dynamic>? images;
  final List<ColorSize>? sizes;

  const ProductColor({
    this.id,
    this.color,
    this.images,
    this.sizes,
  });

  @override
  List<Object?> get props => [
        id,
        color,
        images,
        sizes,
      ];
}
