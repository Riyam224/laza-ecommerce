import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/utils/error_messages.dart';
import 'package:laza/features/home/domain/entities/review_entity.dart';
import 'package:laza/features/home/domain/use_cases/add_review_usecase.dart';
import 'package:laza/features/home/domain/use_cases/get_reviews_usecase.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final GetReviewsUseCase getReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;

  ReviewCubit({
    required this.getReviewsUseCase,
    required this.addReviewUseCase,
  }) : super(ReviewInitial());

  // 🟣 Fetch all reviews for a product
  Future<void> getReviews(String productId) async {
    emit(ReviewLoading());
    try {
      final reviews = await getReviewsUseCase(productId);
      emit(ReviewLoaded(reviews));
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      emit(ReviewError(errorMessage));
    } catch (e) {
      emit(ReviewError(ErrorMessages.getErrorMessage(e)));
    }
  }

  // 🟢 Post a new review
  Future<void> postReview(String productId, ReviewEntity review) async {
    emit(ReviewPosting());
    try {
      await addReviewUseCase(productId, review);
      emit(ReviewPosted("Review added successfully!"));
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      emit(ReviewError(errorMessage));
    } catch (e) {
      emit(ReviewError(ErrorMessages.getErrorMessage(e)));
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
          return 'Reviews not found';
        }
        if (response?.statusCode == 400) {
          return ErrorMessages.badRequest;
        }
        if (response?.statusCode != null && response!.statusCode! >= 500) {
          return ErrorMessages.serverError;
        }
        return 'Failed to load reviews. Please try again.';

      default:
        return ErrorMessages.unexpectedError;
    }
  }
}
