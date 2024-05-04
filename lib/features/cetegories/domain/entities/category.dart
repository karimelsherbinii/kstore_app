import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final int? enabled;
  final List<dynamic>? children;
  final List<dynamic>? images;

  const Category({
     this.id,
     this.name,
     this.description,
     this.enabled,
     this.children,
     this.images,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        enabled,
        children,
        images,
      ];
}
