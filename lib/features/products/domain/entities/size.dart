import 'package:equatable/equatable.dart';

class ProductSize extends Equatable {
  final int? id;
  final String? name;

  const ProductSize({
     this.id,
     this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
