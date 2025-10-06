import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:laza/core/networking/dio_client.dart';
import 'package:laza/features/auth/data/data_sources/auth_api_service.dart';
import 'package:laza/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laza/features/auth/domain/repositories/auth_repository.dart';
import 'package:laza/features/auth/domain/use_cases/register_usecase.dart';
import 'package:laza/features/auth/domain/use_cases/login_usecase.dart';
import 'package:laza/features/auth/domain/use_cases/forgot_password_usecase.dart';
import 'package:laza/features/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:laza/features/auth/domain/use_cases/reset_password_usecase.dart';
import 'package:laza/features/auth/presentation/cubit/register_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/login_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/forgot_password_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  _setupCore();
  _setupAuth();
}

void _setupCore() {
  // ✅ Dio client (shared)
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
}

void _setupAuth() {
  // ✅ API service
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(sl()));

  // ✅ Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // ✅ Use Cases
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<ForgotPasswordUseCase>(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton<ResetPasswordUseCase>(() => ResetPasswordUseCase(sl()));

  // ✅ Cubits
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(sl(), sl(), sl()));
}
