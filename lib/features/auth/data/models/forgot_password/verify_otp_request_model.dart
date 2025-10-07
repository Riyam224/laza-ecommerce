import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/auth/domain/entities/verify_otp_request_entity.dart';

part 'verify_otp_request_model.g.dart';

@JsonSerializable()
class VerifyOtpRequestModel {
  final String email;
  final String otp;

  const VerifyOtpRequestModel({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() => _$VerifyOtpRequestModelToJson(this);

  factory VerifyOtpRequestModel.fromEntity(VerifyOtpRequestEntity entity) {
    return VerifyOtpRequestModel(
      email: entity.email,
      otp: entity.otp,
    );
  }

  VerifyOtpRequestEntity toEntity() {
    return VerifyOtpRequestEntity(
      email: email,
      otp: otp,
    );
  }
}
