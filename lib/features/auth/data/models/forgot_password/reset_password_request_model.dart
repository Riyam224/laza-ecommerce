import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/auth/domain/entities/reset_password_request_entity.dart';

part 'reset_password_request_model.g.dart';

@JsonSerializable()
class ResetPasswordRequestModel {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordRequestModel({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestModelToJson(this);

  factory ResetPasswordRequestModel.fromEntity(
      ResetPasswordRequestEntity entity) {
    return ResetPasswordRequestModel(
      email: entity.email,
      otp: entity.otp,
      newPassword: entity.newPassword,
    );
  }

  ResetPasswordRequestEntity toEntity() {
    return ResetPasswordRequestEntity(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
  }
}
