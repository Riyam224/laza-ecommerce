import '../../domain/entities/product_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductEntity>> getProducts() async {
    final result = await remoteDataSource.getProducts();
    return result.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    final model = await remoteDataSource.getProductById(id);
    return model.toEntity();
  }

  @override
  Future<List<ReviewEntity>> getReviews(String productId) async {
    final result = await remoteDataSource.getReviews(productId);
    return result.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addReview(String productId, ReviewEntity review) async {
    await remoteDataSource.addReview(productId, {
      'comment': review.comment,
      'rating': review.rating,
      'reviewerName': review.reviewerName,
    });
  }
}
