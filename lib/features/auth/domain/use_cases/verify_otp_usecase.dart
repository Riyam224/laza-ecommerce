import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import '../entities/verify_otp_request_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, void>> call(VerifyOtpRequestEntity request) {
    return repository.verifyOtp(request);
  }
}
