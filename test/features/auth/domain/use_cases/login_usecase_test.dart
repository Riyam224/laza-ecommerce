import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';
import 'package:laza/features/auth/domain/entities/login_response_entity.dart';
import 'package:laza/features/auth/domain/use_cases/login_usecase.dart';
import 'package:laza/features/auth/domain/repositories/auth_repository.dart';
import 'package:laza/core/error/failure.dart';

/// 🧠 نعمل Mock للـ Repository الحقيقي
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepo);
  });

  /// مهم جدًا في mocktail — نخبره بأن LoginRequestEntity يمكن استخدامه كـ parameter
  setUpAll(() {
    registerFallbackValue(LoginRequestEntity(email: '', password: ''));
  });

  test('✅ LoginUseCase returns success when credentials are correct', () async {
    // Arrange
    final request = LoginRequestEntity(
      email: 'test@email.com',
      password: '123456',
    );
    final response = LoginResponseEntity(
      accessToken: 'abc123',
      refreshToken: '',
      expiresAtUtc: '',
    );

    // 🧩 هنا نخبر mocktail أن دالة login سترجع Future<Either<Failure, LoginResponseEntity>>
    when(() => mockRepo.login(any())).thenAnswer((_) async => Right(response));

    // Act
    final result = await loginUseCase(request);

    // Assert
    expect(result, Right(response));
    verify(() => mockRepo.login(request)).called(1);
  });

  test('❌ LoginUseCase returns failure when login fails', () async {
    final request = LoginRequestEntity(
      email: 'wrong@email.com',
      password: 'bad',
    );

    when(() => mockRepo.login(any())).thenAnswer(
      (_) async => Left(ServerFailure(message: 'Invalid credentials')),
    );

    final result = await loginUseCase(request);

    expect(result, Left(ServerFailure(message: 'Invalid credentials')));
  });
}
