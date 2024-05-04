import 'package:equatable/equatable.dart';

class Status extends Equatable {
  final int id;
  final String title;
  final String description;
  final String createdAt;
  final int status;

  const Status({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        createdAt,
        status,
      ];
}
