import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/utils/error_messages.dart';
import 'package:laza/features/home/domain/entities/product_entity.dart';
import 'package:laza/features/home/domain/use_cases/get_products_usecase.dart';
import 'package:laza/features/home/domain/use_cases/get_product_by_id_usecase.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;
  List<ProductEntity>? _allProducts;

  ProductCubit({
    required this.getProductsUseCase,
    required this.getProductByIdUseCase,
  }) : super(ProductInitial());

  // 🟣 Fetch all products
  Future<void> getProducts() async {
    emit(ProductLoading());
    try {
      final products = await getProductsUseCase();
      _allProducts = products;
      emit(ProductLoaded(products));
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      emit(ProductError(errorMessage));
    } catch (e) {
      emit(ProductError(ErrorMessages.getErrorMessage(e)));
    }
  }

  // 🔍 Search products locally
  void searchProducts(String query) {
    if (_allProducts == null) {
      return;
    }

    if (query.isEmpty) {
      emit(ProductLoaded(_allProducts!));
      return;
    }

    final filteredProducts = _allProducts!.where((product) {
      final nameLower = product.name.toLowerCase();
      final descriptionLower = product.description.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower) || descriptionLower.contains(queryLower);
    }).toList();

    emit(ProductSearchLoaded(filteredProducts, query));
  }

  // 🟢 Fetch product by ID
  Future<void> getProductById(String id) async {
    emit(ProductDetailLoading());
    try {
      final product = await getProductByIdUseCase(id);
      emit(ProductDetailLoaded(product));
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      emit(ProductError(errorMessage));
    } catch (e) {
      emit(ProductError(ErrorMessages.getErrorMessage(e)));
    }
  }

  /// Handles Dio-specific exceptions clearly
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

        // ✅ Handle server messages precisely
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
          return 'Product not found';
        }
        if (response?.statusCode == 400) {
          return ErrorMessages.badRequest;
        }
        if (response?.statusCode != null && response!.statusCode! >= 500) {
          return ErrorMessages.serverError;
        }
        return 'Failed to load product. Please try again.';

      default:
        return ErrorMessages.unexpectedError;
    }
  }
}
