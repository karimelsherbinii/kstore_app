import 'package:kstore/features/notifications/domain/entities/notification.dart';
import 'package:kstore/features/orders/data/models/order_model.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    super.id,
    super.message,
    super.order,
    super.readAt,
    super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      message: json['message'],
      order:  json['order'] != null ? OrderModel.fromJson(json['order']) : null,
      readAt: json['read_at'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'order': order,
      'read_at': readAt,
      'created_at': createdAt,
    };
  }
}
