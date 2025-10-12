// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   test('example', () {
//     expect(1 + 1, equals(2));
//   });
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:laza/features/auth/data/models/register/register_response_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:laza/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laza/features/auth/data/data_sources/auth_api_service.dart';
import 'package:laza/features/auth/data/models/login/login_request_model.dart';
import 'package:laza/features/auth/data/models/login/login_response_model.dart';
import 'package:laza/features/auth/data/models/register/register_request_model.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';
import 'package:laza/features/auth/domain/entities/login_response_entity.dart';
import 'package:laza/core/error/failure.dart';

/// ✅ Mock for AuthApiService
class MockAuthApiService extends Mock implements AuthApiService {}

/// ✅ Fake for LoginRequestModel
class FakeLoginRequestModel extends Fake implements LoginRequestModel {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthApiService mockApi;

  setUpAll(() {
    registerFallbackValue(FakeLoginRequestModel());
  });

  setUp(() {
    mockApi = MockAuthApiService();
    repository = AuthRepositoryImpl(mockApi);
  });

  group('🧪 AuthRepositoryImpl Tests', () {
    // ---------------------- LOGIN TEST ----------------------
    test('✅ login returns Right(LoginResponseEntity) on success', () async {
      final request = LoginRequestEntity(
        email: 'test@email.com',
        password: '123456',
      );

      final mockResponse = LoginResponseModel(
        accessToken: 'token123',
        refreshToken: 'refresh456',
        expiresAtUtc: '2025-10-12T00:00:00Z',
      );

      when(() => mockApi.login(any())).thenAnswer((_) async => mockResponse);

      final result = await repository.login(request);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected Right but got Left'), (entity) {
        expect(entity.accessToken, 'token123');
        expect(entity.refreshToken, 'refresh456');
      });

      verify(() => mockApi.login(any())).called(1);
    });

    test('❌ login returns Left(ServerFailure) on DioException', () async {
      final request = LoginRequestEntity(
        email: 'wrong@email.com',
        password: 'bad',
      );

      when(() => mockApi.login(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 400,
            data: {"message": "Invalid credentials"},
          ),
        ),
      );

      final result = await repository.login(request);

      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(
          failure.message,
          contains('Invalid credentials'),
        ); // ✅ بدل Login failed
      }, (_) => fail('Expected Left but got Right'));
    });

    // ---------------------- REGISTER TEST ----------------------
    test(
      '✅ register returns Right(RegisterResponseEntity) on success',
      () async {
        final request = RegisterRequestModel(
          email: 'user@test.com',
          password: '123456',
          firstName: 'Riyam',
          lastName: 'Tester',
        );

        when(() => mockApi.register(request)).thenAnswer(
          (_) async =>
              RegisterResponseModel(message: 'Registered successfully'),
        );

        final result = await repository.register(request);

        expect(result.isRight(), true);
        verify(() => mockApi.register(request)).called(1);
      },
    );

    test('❌ register returns Left(ServerFailure) on error', () async {
      final request = RegisterRequestModel(
        email: 'error@test.com',
        password: '123456',
        firstName: 'Error',
        lastName: 'User',
      );

      when(() => mockApi.register(request)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/register'),
            statusCode: 500,
            data: {"message": "Server error"},
          ),
        ),
      );

      final result = await repository.register(request);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });
}
