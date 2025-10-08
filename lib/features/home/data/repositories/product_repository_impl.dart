import 'package:laza/features/home/data/data_sources/product_remote_data_source.dart';
import 'package:laza/features/home/data/models/product_model.dart';
import 'package:laza/features/home/domain/entities/product_entity.dart';
import 'package:laza/features/home/domain/entities/review_entity.dart';
import 'package:laza/features/home/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  // ✅ Get all products
  @override
  Future<List<ProductEntity>> getProducts() async {
    final queries = {"page": 1, "pageSize": 20};

    final httpResponse = await remoteDataSource.getProducts(queries);

    final data = httpResponse.data as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;

    final products = items
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return products.map((p) => p.toEntity()).toList();
  }

  // ✅ Get single product details by ID
  @override
  Future<ProductEntity> getProductById(String id) async {
    final product = await remoteDataSource.getProductById(id);
    return product.toEntity();
  }

  // ✅ Get reviews for a product
  @override
  Future<List<ReviewEntity>> getReviews(String productId) async {
    final reviewModels = await remoteDataSource.getReviews(productId);
    return reviewModels.map((r) => r.toEntity()).toList();
  }

  // ✅ Add a new review for a product
  @override
  Future<void> addReview(String productId, ReviewEntity review) async {
    final body = {
      "userName": review.userName,
      "comment": review.comment,
      "rating": review.rating,
    };
    await remoteDataSource.addReview(productId, body);
  }
}
