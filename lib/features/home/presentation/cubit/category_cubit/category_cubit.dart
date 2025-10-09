import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/error/auth_error_msg.dart';
import 'package:laza/features/home/domain/use_cases/get_categories_usecase.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryCubit({
    required this.getCategoriesUseCase,
  }) : super(CategoryInitial());

  Future<void> getCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await getCategoriesUseCase();
      emit(CategoryLoaded(categories));
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      emit(CategoryError(errorMessage));
    } catch (e) {
      emit(CategoryError(ErrorMessages.getErrorMessage(e)));
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ErrorMessages.timeout;

      case DioExceptionType.connectionError:
        return ErrorMessages.noInternet;

      case DioExceptionType.cancel:
        return 'Request cancelled by user';

      case DioExceptionType.badResponse:
        final response = e.response;
        final data = response?.data;

        if (data is Map<String, dynamic>) {
          if (data.containsKey('message')) return data['message'];

          if (data['errors'] is Map && data['errors'].isNotEmpty) {
            final errors = data['errors'] as Map;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first;
            }
          }
        }

        if (response?.statusCode == 404) {
          return 'Categories not found';
        }
        if (response?.statusCode == 400) {
          return ErrorMessages.badRequest;
        }
        if (response?.statusCode != null && response!.statusCode! >= 500) {
          return ErrorMessages.serverError;
        }
        return 'Failed to load categories. Please try again.';

      default:
        return ErrorMessages.unexpectedError;
    }
  }
}
