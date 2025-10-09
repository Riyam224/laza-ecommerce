import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/error/auth_error_msg.dart';
import 'package:laza/features/home/domain/entities/review_entity.dart';
import 'package:laza/features/home/domain/use_cases/add_review_usecase.dart';
import 'package:laza/features/home/domain/use_cases/get_reviews_usecase.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final GetReviewsUseCase getReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;

  ReviewCubit({required this.getReviewsUseCase, required this.addReviewUseCase})
    : super(ReviewInitial());

  //  Fetch all reviews for a product
  Future<void> getReviews(String productId) async {
    emit(ReviewLoading());
    try {
      final reviews = await getReviewsUseCase(productId);
      emit(ReviewLoaded(reviews));
    } on DioException catch (e) {
      emit(ReviewError(_handleDioError(e)));
    } catch (e) {
      emit(ReviewError(ErrorMessages.getErrorMessage(e)));
    }
  }

  //  Post a new review
  Future<void> postReview(String productId, ReviewEntity review) async {
    emit(ReviewPosting());
    try {
      //  Convert rating to int before sending
      final fixedReview = ReviewEntity(
        userName: review.userName,
        comment: review.comment,
        rating: review.rating.toInt(),
      );

      await addReviewUseCase(productId, fixedReview);
      emit(ReviewPosted("✅ Review added successfully!"));

      // Refresh reviews immediately
      await getReviews(productId);
    } on DioException catch (e) {
      emit(ReviewError(_handleDioError(e)));
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
          // 🧩 Return server-specific error instead of a generic one
          return data?['message'] ?? ErrorMessages.badRequest;
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
