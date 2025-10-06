import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';

part 'login_request_model.g.dart';

@JsonSerializable()
class LoginRequestModel extends LoginRequestEntity {
  const LoginRequestModel({
    required super.email,
    required super.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);

  factory LoginRequestModel.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModel(
      email: entity.email,
      password: entity.password,
    );
  }
}
