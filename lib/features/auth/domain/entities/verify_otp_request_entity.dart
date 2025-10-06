import 'package:equatable/equatable.dart';

class VerifyOtpRequestEntity extends Equatable {
  final String email;
  final String otp;

  const VerifyOtpRequestEntity({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}
