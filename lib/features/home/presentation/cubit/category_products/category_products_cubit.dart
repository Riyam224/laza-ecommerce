import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/error/auth_error_msg.dart';
import 'package:laza/features/home/domain/entities/product_entity.dart';
import 'package:laza/features/home/domain/use_cases/get_products_by_category_usecase.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  CategoryProductsCubit(this.getProductsByCategoryUseCase)
      : super(const CategoryProductsInitial());

  Future<void> loadCategoryProducts(String categoryId) async {
    emit(const CategoryProductsLoading());
    try {
      final products = await getProductsByCategoryUseCase(categoryId);
      emit(CategoryProductsLoaded(
        products: products,
        categoryId: categoryId,
      ));
    } on DioException catch (e) {
      emit(CategoryProductsError(_handleDioError(e)));
    } catch (e) {
      emit(CategoryProductsError(ErrorMessages.getErrorMessage(e)));
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
        }

        if (response?.statusCode == 404) {
          return 'No products found in this category';
        }
        if (response?.statusCode == 400) {
          return ErrorMessages.badRequest;
        }
        if (response?.statusCode != null && response!.statusCode! >= 500) {
          return ErrorMessages.serverError;
        }
        return 'Failed to load products. Please try again.';

      default:
        return ErrorMessages.unexpectedError;
    }
  }
}
