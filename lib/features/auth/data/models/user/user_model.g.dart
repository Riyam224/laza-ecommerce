// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: json['userId'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  profilePicture: json['profilePicture'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'fullName': instance.fullName,
  'profilePicture': instance.profilePicture,
};
