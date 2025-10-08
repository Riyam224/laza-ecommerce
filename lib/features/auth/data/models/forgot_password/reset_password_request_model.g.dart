// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordRequestModel _$ResetPasswordRequestModelFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequestModel(
  email: json['email'] as String,
  otp: json['otp'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestModelToJson(
  ResetPasswordRequestModel instance,
) => <String, dynamic>{
  'email': instance.email,
  'otp': instance.otp,
  'newPassword': instance.newPassword,
};
