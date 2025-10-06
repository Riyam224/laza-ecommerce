import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:laza/core/networking/dio_client.dart';
import 'package:laza/features/auth/data/data_sources/auth_api_service.dart';
import 'package:laza/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laza/features/auth/domain/use_cases/register_usecase.dart';
import 'package:laza/features/auth/presentation/cubit/register_cubit.dart';

final sl = GetIt.instance;

setupDependencies() {
  _setupAuth();
}

_setupAuth() {
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(sl()));
  sl.registerLazySingleton<AuthRepositoryImpl>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl()));
}
