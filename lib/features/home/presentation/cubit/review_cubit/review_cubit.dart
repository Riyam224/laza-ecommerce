import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/home/domain/entities/review_entity.dart';
import 'package:laza/features/home/domain/use_cases/add_review_usecase.dart';
import 'package:laza/features/home/domain/use_cases/get_reviews_usecase.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final GetReviewsUseCase getReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;

  ReviewCubit({required this.getReviewsUseCase, required this.addReviewUseCase})
    : super(ReviewInitial());

  // 🟣 Fetch all reviews for a product
  Future<void> getReviews(String productId) async {
    emit(ReviewLoading());
    try {
      final reviews = await getReviewsUseCase(productId);
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  // 🟢 Post a new review
  Future<void> postReview(String productId, ReviewEntity review) async {
    emit(ReviewPosting());
    try {
      await addReviewUseCase(productId, review);
      emit(ReviewPosted("Review added successfully!"));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
