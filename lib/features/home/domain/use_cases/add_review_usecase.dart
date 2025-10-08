import '../entities/review_entity.dart';
import '../repositories/product_repository.dart';

class AddReviewUseCase {
  final ProductRepository repository;

  AddReviewUseCase(this.repository);

  Future<void> call(String productId, ReviewEntity review) async {
    return await repository.addReview(productId, review);
  }
}
