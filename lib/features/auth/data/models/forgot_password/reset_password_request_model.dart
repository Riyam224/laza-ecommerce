import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/auth/domain/entities/reset_password_request_entity.dart';

part 'reset_password_request_model.g.dart';

@JsonSerializable()
class ResetPasswordRequestModel extends ResetPasswordRequestEntity {
  const ResetPasswordRequestModel({
    required super.email,
    required super.otp,
    required super.newPassword,
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
}
