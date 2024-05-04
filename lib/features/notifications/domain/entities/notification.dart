import 'package:equatable/equatable.dart';
import 'package:kstore/features/orders/domain/entities/order.dart';

class Notification extends Equatable{

final String? id;
final String? message;
final Order? order;
final String? readAt;
final String? createdAt;

  const Notification({
    this.id,
    this.message,
    this.order,
    this.readAt,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        message,
        order,
        readAt,
        createdAt,
      ];

}