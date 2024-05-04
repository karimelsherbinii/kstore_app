import '../../domain/entities/status.dart';

class StatusModel extends Status {
  const StatusModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.createdAt,
      required super.status});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'],
      status: json['status'],
    );
  }
}
