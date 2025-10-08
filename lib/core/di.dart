

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// 🌍 Core
import 'package:laza/core/networking/dio_client.dart';

// 🔐 Auth Feature
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

// 🛍️ Product + Review Feature
import 'package:laza/features/home/domain/use_cases/get_product_by_id_usecase.dart';
import 'package:laza/features/home/domain/use_cases/get_products_usecase.dart';
import 'package:laza/features/home/domain/use_cases/get_reviews_usecase.dart';
import 'package:laza/features/home/domain/use_cases/add_review_usecase.dart';
import 'package:laza/features/home/domain/repositories/product_repository.dart';
import 'package:laza/features/home/data/repositories/product_repository_impl.dart';
import 'package:laza/features/home/data/data_sources/product_remote_data_source.dart';
import 'package:laza/features/home/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  _setupCore();
  _setupAuth();
  _setupProducts();
}

void _setupCore() {
  // ✅ 1. Dio Client
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
}

void _setupAuth() {
  // ✅ 2. Auth Remote Data Source (Retrofit)
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(sl()));

  // ✅ 3. Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // ✅ 4. Use Cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  // ✅ 5. Cubits
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => ForgotPasswordCubit(sl(), sl(), sl()));
}

void _setupProducts() {
  // ✅ 6. Product Remote Data Source (Retrofit)
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(sl()),
  );

  // ✅ 7. Product Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  // ✅ 8. Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetReviewsUseCase(sl()));
  sl.registerLazySingleton(() => AddReviewUseCase(sl()));

  // ✅ 9. Cubits
  sl.registerFactory(() => ProductCubit(sl()));
  sl.registerFactory(
    () => ReviewCubit(getReviewsUseCase: sl(), addReviewUseCase: sl()),
  );
}
