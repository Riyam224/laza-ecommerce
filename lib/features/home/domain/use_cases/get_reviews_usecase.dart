import '../entities/review_entity.dart';
import '../repositories/product_repository.dart';

class GetReviewsUseCase {
  final ProductRepository repository;

  GetReviewsUseCase(this.repository);

  Future<List<ReviewEntity>> call(String productId) async {
    return await repository.getReviews(productId);
  }
}
