import 'package:laza/features/home/data/data_sources/product_remote_data_source.dart';
import 'package:laza/features/home/data/models/product_model.dart';
import 'package:laza/features/home/data/models/review_model.dart';
import 'package:laza/features/home/domain/entities/product_entity.dart';
import 'package:laza/features/home/domain/entities/review_entity.dart';
import 'package:laza/features/home/domain/entities/category_entity.dart';
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
    final httpResponse = await remoteDataSource.getReviews(productId, 1, 10);
    final data = httpResponse.data as Map<String, dynamic>;

    // ✅ Navigate to nested structure
    final items = data['reviews']?['items'] as List<dynamic>? ?? [];

    final reviews = items
        .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return reviews.map((r) => r.toEntity()).toList();
  }

  // ✅ Add a new review for a product
  @override
  Future<void> addReview(String productId, ReviewEntity review) async {
    final body = {
      'userName': review.userName,
      'comment': review.comment,
      'rating': review.rating.toInt(), // ✅ convert here, not in the entity
    };
    await remoteDataSource.addReview(productId, body);
  }

  // ✅ Get all categories
  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      // 🚀 Directly returns CategoryResponse, not HttpResponse
      final response = await remoteDataSource.getCategories();

      // ✅ response.categories is already a List<CategoryModel>
      return response.categories.map((e) => e.toEntity()).toList();
    } catch (e, s) {
      // Optional: add logging
      print("❌ Failed to load categories: $e\n$s");
      throw Exception("Failed to load categories: $e");
    }
  }

  // todo
  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoryName) async {
    try {
      final response = await remoteDataSource.getProductsByCategory(
        categoryName,
        1, // page
        20, // pageSize
      );

      final data = response.data['items'] as List<dynamic>;
      return data.map((e) => ProductModel.fromJson(e).toEntity()).toList();
    } catch (e) {
      throw Exception(
        "Failed to load products for category '$categoryName': $e",
      );
    }
  }
}
