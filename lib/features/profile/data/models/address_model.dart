import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel(
      {required super.id,
      required super.street,
      required super.city,
      required super.state,
      required super.zip,
      required super.country,
      required super.createdAt,
      required super.updatedAt});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
