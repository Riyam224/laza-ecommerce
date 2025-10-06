import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/auth/domain/entities/forgot_password_request_entity.dart';

part 'forgot_password_request_model.g.dart';

@JsonSerializable()
class ForgotPasswordRequestModel extends ForgotPasswordRequestEntity {
  const ForgotPasswordRequestModel({required super.email});

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestModelToJson(this);

  factory ForgotPasswordRequestModel.fromEntity(
      ForgotPasswordRequestEntity entity) {
    return ForgotPasswordRequestModel(email: entity.email);
  }
}
