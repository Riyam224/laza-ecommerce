import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laza/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/login/login_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:laza/features/auth/domain/use_cases/login_usecase.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';
import 'package:laza/features/auth/domain/entities/login_response_entity.dart';
import 'package:laza/core/error/failure.dart';
import 'package:bloc_test/bloc_test.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({}); // ✅ هذا يحاكي التخزين المحلي
  late MockLoginUseCase mockLoginUseCase;
  late LoginCubit loginCubit;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginCubit = LoginCubit(mockLoginUseCase);
  });

  tearDown(() {
    loginCubit.close();
  });

  group('🧪 LoginCubit Tests', () {
    final request = LoginRequestEntity(
      email: 'test@email.com',
      password: '123456',
    );
    final response = LoginResponseEntity(
      accessToken: 'token123',
      refreshToken: 'refresh456',
      expiresAtUtc: '2025-10-12T00:00:00Z',
    );

    blocTest<LoginCubit, LoginState>(
      '✅ emits [Loading, Success] when login is successful',
      build: () {
        when(
          () => mockLoginUseCase(request),
        ).thenAnswer((_) async => Right(response));
        return loginCubit;
      },
      act: (cubit) =>
          cubit.loginUser(email: request.email, password: request.password),
      expect: () => [LoginLoading(), LoginSuccess(response)],
      verify: (_) {
        verify(() => mockLoginUseCase(request)).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      '❌ emits [Loading, Error] when login fails',
      build: () {
        when(() => mockLoginUseCase(request)).thenAnswer(
          (_) async => Left(ServerFailure(message: 'Invalid credentials')),
        );
        return loginCubit;
      },
      act: (cubit) =>
          cubit.loginUser(email: request.email, password: request.password),
      expect: () => [LoginLoading(), LoginError('Invalid credentials')],
    );
  });
}
