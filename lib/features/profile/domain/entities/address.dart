import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int? id;
  final String? street;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;
  final String? createdAt;
  final String? updatedAt;

  const Address({
     this.id,
     this.street,
     this.city,
     this.state,
     this.zip,
     this.country,
     this.createdAt,
     this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        street,
        city,
        state,
        zip,
        country,
        createdAt,
        updatedAt,
      ];
}
