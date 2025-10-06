import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/auth/domain/entities/login_response_entity.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel extends LoginResponseEntity {
  const LoginResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAtUtc,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
