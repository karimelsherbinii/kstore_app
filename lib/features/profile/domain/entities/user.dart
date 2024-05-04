import 'package:equatable/equatable.dart';
import 'package:kstore/features/profile/domain/entities/address.dart';

class User extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? userName;
  String? email;
  final String? birthDate;
  final String? phone;
  final String? role;
  final String? createdAt;
  final String? profileImage;
  final String? gender;
  final List<Address>? address;
  String? token;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.birthDate,
    this.phone,
    this.role,
    this.createdAt,
    this.profileImage,
    this.gender,
    this.address,
    this.token,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        userName,
        email,
        birthDate,
        phone,
        role,
        createdAt,
        profileImage,
        gender,
        address,
        token,
      ];
}
