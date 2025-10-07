import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/auth/domain/entities/forgot_password_request_entity.dart';

part 'forgot_password_request_model.g.dart';

@JsonSerializable()
class ForgotPasswordRequestModel {
  final String email;

  const ForgotPasswordRequestModel({required this.email});

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestModelToJson(this);

  factory ForgotPasswordRequestModel.fromEntity(
      ForgotPasswordRequestEntity entity) {
    return ForgotPasswordRequestModel(email: entity.email);
  }

  ForgotPasswordRequestEntity toEntity() {
    return ForgotPasswordRequestEntity(email: email);
  }
}
