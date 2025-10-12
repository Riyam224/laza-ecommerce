import 'package:flutter_test/flutter_test.dart';
import 'package:laza/features/auth/data/models/login/login_request_model.dart';
import 'package:laza/features/auth/data/models/login/login_response_model.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';
import 'package:laza/features/auth/domain/entities/login_response_entity.dart';

void main() {
  group('🧩 Login Models Tests', () {
    // 🧠 اختبار LoginRequestModel
    test('✅ LoginRequestModel fromEntity & toJson work correctly', () {
      // Arrange → نجهز البيانات
      final entity = LoginRequestEntity(
        email: 'test@email.com',
        password: '123456',
      );

      // Act → نحول الـ entity إلى model
      final model = LoginRequestModel.fromEntity(entity);
      final json = model.toJson();

      // Assert → نتحقق من النتائج
      expect(model.email, 'test@email.com');
      expect(model.password, '123456');
      expect(json, {'email': 'test@email.com', 'password': '123456'});
    });

    // 🧠 اختبار LoginResponseModel
    test(
      '✅ LoginResponseModel fromJson, toJson, and toEntity work correctly',
      () {
        // Arrange → نحضر JSON يشبه استجابة السيرفر
        final json = {
          'accessToken': 'token123',
          'refreshToken': 'refresh456',
          'expiresAtUtc': '2025-10-12T00:00:00Z',
        };

        // Act → نحول JSON إلى model
        final model = LoginResponseModel.fromJson(json);

        // Assert → نتحقق من القيم داخل الموديل
        expect(model.accessToken, 'token123');
        expect(model.refreshToken, 'refresh456');
        expect(model.expiresAtUtc, '2025-10-12T00:00:00Z');

        // Act → نحول الموديل إلى JSON مرة أخرى
        final newJson = model.toJson();
        expect(newJson, json); // لازم تكون متطابقة تمامًا

        // Act → نحول إلى entity (اللي تستخدمه الـ domain layer)
        final entity = model.toEntity();

        // Assert → نتحقق من الـ entity
        expect(entity, isA<LoginResponseEntity>());
        expect(entity.accessToken, 'token123');
        expect(entity.refreshToken, 'refresh456');
      },
    );
  });
}
