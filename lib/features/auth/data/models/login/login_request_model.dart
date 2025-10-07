import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';

part 'login_request_model.g.dart';

@JsonSerializable()
class LoginRequestModel {
  final String email;
  final String password;

  const LoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);

  factory LoginRequestModel.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModel(
      email: entity.email,
      password: entity.password,
    );
  }

  LoginRequestEntity toEntity() {
    return LoginRequestEntity(
      email: email,
      password: password,
    );
  }
}
