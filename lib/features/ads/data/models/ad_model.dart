import 'package:kstore/features/ads/domain/entities/ad.dart';

class AdModel extends Ad {
  AdModel({
    super.id,
    super.title,
    super.description,
    super.endDate,
    super.image,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      endDate: json['end_date'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'end_date': endDate,
      'image': image,
    };
  }
}
