// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   test('example', () {
//     expect(1 + 1, equals(2));
//   });
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:laza/features/auth/data/data_sources/auth_api_service.dart';
import 'package:laza/features/auth/data/models/login/login_request_model.dart';
import 'package:laza/features/auth/data/models/login/login_response_model.dart';

/// ✅ Fake for RequestOptions
class FakeRequestOptions extends Fake implements RequestOptions {}

/// ✅ Mock for Dio
class MockDio extends Mock implements Dio {
  @override
  BaseOptions get options => BaseOptions();
}

void main() {
  late MockDio mockDio;
  late AuthApiService apiService;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  setUp(() {
    mockDio = MockDio();
    apiService = AuthApiService(mockDio, baseUrl: 'https://fakeapi.test');
  });

  group('🧪 AuthApiService Tests', () {
    test('✅ returns LoginResponseModel on successful login', () async {
      final request = LoginRequestModel(
        email: 'test@email.com',
        password: '123456',
      );

      final fakeResponse = {
        "accessToken": "token123",
        "refreshToken": "refresh456",
        "expiresAtUtc": "2025-10-12T00:00:00Z",
      };

      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          statusCode: 200,
          data: fakeResponse,
        ),
      );

      final result = await apiService.login(request);

      expect(result, isA<LoginResponseModel>());
      expect(result.accessToken, 'token123');
      expect(result.refreshToken, 'refresh456');
    });

    test('❌ throws DioException on 400 error', () async {
      final request = LoginRequestModel(
        email: 'wrong@email.com',
        password: 'bad',
      );

      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/login'),
            statusCode: 400,
            data: {"message": "Invalid credentials"},
          ),
        ),
      );

      expect(() => apiService.login(request), throwsA(isA<DioException>()));
    });
  });
}
