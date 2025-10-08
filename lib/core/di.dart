import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import 'package:laza/features/auth/domain/use_cases/GetUserInfoUseCase.dart';
import 'package:laza/features/auth/presentation/cubit/register_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/login_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/user_info_cubit.dart';

// 🛍️ Product + Review + Category Feature
import 'package:laza/features/home/domain/use_cases/get_product_by_id_usecase.dart';
import 'package:laza/features/home/domain/use_cases/get_products_usecase.dart';
import 'package:laza/features/home/domain/use_cases/get_reviews_usecase.dart';
import 'package:laza/features/home/domain/use_cases/add_review_usecase.dart';
import 'package:laza/features/home/domain/use_cases/get_categories_usecase.dart';
import 'package:laza/features/home/domain/use_cases/get_products_by_category_usecase.dart';
import 'package:laza/features/home/domain/repositories/product_repository.dart';
import 'package:laza/features/home/data/repositories/product_repository_impl.dart';
import 'package:laza/features/home/data/data_sources/product_remote_data_source.dart';
import 'package:laza/features/home/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:laza/features/home/presentation/cubit/category_cubit/category_cubit.dart';
import 'package:laza/features/home/presentation/cubit/category_products/category_products_cubit.dart';

// 🛒 Cart Feature
import 'package:laza/features/cart/data/data_sources/cart_remote_data_source.dart';
import 'package:laza/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:laza/features/cart/domain/repositories/cart_repository.dart';
import 'package:laza/features/cart/domain/use_cases/add_to_cart_usecase.dart';
import 'package:laza/features/cart/domain/use_cases/clear_cart_usecase.dart';
import 'package:laza/features/cart/domain/use_cases/get_cart_items_usecase.dart';
import 'package:laza/features/cart/domain/use_cases/remove_from_cart_usecase.dart';
import 'package:laza/features/cart/domain/use_cases/update_cart_quantity_usecase.dart';
import 'package:laza/features/cart/presentation/cubit/cart_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await _setupCore();
  _setupAuth();
  _setupProducts();
  _setupCart();
}

Future<void> _setupCore() async {
  // ✅ 1. Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ✅ 2. Dio Client
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
  sl.registerLazySingleton(() => GetUserInfoUseCase(sl()));

  // ✅ 5. Cubits
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => ForgotPasswordCubit(sl(), sl(), sl()));
  sl.registerFactory(() => UserInfoCubit(sl()));
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
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsByCategoryUseCase(sl()));

  // ✅ 9. Cubits
  sl.registerFactory(
    () => ProductCubit(getProductsUseCase: sl(), getProductByIdUseCase: sl()),
  );
  sl.registerFactory(
    () => ReviewCubit(getReviewsUseCase: sl(), addReviewUseCase: sl()),
  );
  sl.registerFactory(() => CategoryCubit(getCategoriesUseCase: sl()));
  sl.registerFactory(() => CategoryProductsCubit(sl()));
}

void _setupCart() {
  // ✅ 10. Cart Remote Data Source
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSource(sl()),
  );

  // ✅ 11. Cart Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl()),
  );

  // ✅ 12. Use Cases
  sl.registerLazySingleton(() => GetCartItemsUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartQuantityUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));

  // ✅ 13. Cubit
  sl.registerFactory(
    () => CartCubit(
      getCartItems: sl(),
      addToCart: sl(),
      removeFromCart: sl(),
      updateQuantity: sl(),
      clearCart: sl(),
    ),
  );
}
