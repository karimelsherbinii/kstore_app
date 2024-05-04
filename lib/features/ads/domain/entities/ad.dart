import 'package:equatable/equatable.dart';

class Ad extends Equatable{
  final int? id;
  final String? title;
  final String? description;
  final String? endDate;
  final String? image;

  const Ad({
     this.id,
     this.title,
     this.description,
     this.endDate,
     this.image,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    endDate,
    image,
  ];
}