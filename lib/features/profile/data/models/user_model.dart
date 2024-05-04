import 'package:kstore/features/profile/data/models/address_model.dart';
import 'package:kstore/features/profile/domain/entities/user.dart';

class UserModel extends User {
   UserModel({
    super.id,
    super.firstName,
    super.lastName,
    super.userName,
    super.email,
    super.birthDate,
    super.phone,
    super.role,
    super.createdAt,
    super.profileImage,
    super.gender,
    super.address,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      userName: json['username'],
      email: json['email'],
      birthDate: json['birth_date'],
      phone: json['phone'],
      role: json['role'],
      createdAt: json['created_at'],
      profileImage: json['profile_image'],
      gender: json['gender'],
      address: json['address'] != null
          ? (json['address'] as List)
              .map((i) => AddressModel.fromJson(i))
              .toList()
          : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': userName,
      'email': email,
      'birth_date': birthDate,
      'phone': phone,
      'role': role,
      'created_at': createdAt,
      'profile_image': profileImage,
      'gender': gender,
      'address': address,
      'token': token,
    };
  }
}
