import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String userId;
  final String email;
  final String fullName;
  final String? profilePicture;

  const UserModel({
    required this.userId,
    required this.email,
    required this.fullName,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      email: email,
      fullName: fullName,
      profilePicture: profilePicture,
    );
  }
}
