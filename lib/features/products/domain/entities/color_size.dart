import 'package:equatable/equatable.dart';

class ColorSize extends Equatable {
  final int? id;
  final String? size;
  final int? price;
  final int? discount;
  final int? quantity;
  final int? productId;
  const ColorSize({
    this.id,
    this.size,
    this.price,
    this.discount,
    this.quantity,
    this.productId,
  });
  @override
  List<Object?> get props => [
        id,
        size,
        price,
        discount,
        quantity,
      ];
}
