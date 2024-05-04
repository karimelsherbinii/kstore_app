import 'package:kstore/features/cetegories/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required int id,
    required String name,
    required String description,
    required int enabled,
    required List<dynamic> children,
    required List<dynamic> images,
  }) : super(
          id: id,
          name: name,
          description: description,
          enabled: enabled,
          children: children,
          images: images,
        );

  factory CategoryModel.formJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      enabled: json['enabled'],
      children: json['children'],
      images: json['images'],
    );
  }
}
