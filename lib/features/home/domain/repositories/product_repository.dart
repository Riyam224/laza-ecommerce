import '../entities/product_entity.dart';
import '../entities/review_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<ProductEntity> getProductById(String id);
  Future<List<ReviewEntity>> getReviews(String productId);
  Future<void> addReview(String productId, ReviewEntity review);
}
