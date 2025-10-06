import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String expiresAtUtc;

  const LoginResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAtUtc,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAtUtc];
}
