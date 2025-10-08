import 'package:dio/dio.dart';
import 'package:laza/features/home/data/models/review_model.dart';
import 'package:retrofit/retrofit.dart';
import '../models/product_model.dart';

part 'product_remote_data_source.g.dart';

@RestApi(baseUrl: "https://accessories-eshop.runasp.net/api/")
abstract class ProductRemoteDataSource {
  factory ProductRemoteDataSource(Dio dio, {String baseUrl}) =
      _ProductRemoteDataSource;

  // ✅ Get all products
  @GET("products")
  Future<List<ProductModel>> getProducts();

  // ✅ Get product by ID
  @GET("products/{id}")
  Future<ProductModel> getProductById(@Path("id") String id);

  // ✅ Get reviews for a product
  @GET("reviews/{productId}")
  Future<List<ReviewModel>> getReviews(@Path("productId") String productId);

  // ✅ Add a new review
  @POST("reviews/{productId}")
  Future<void> addReview(
    @Path("productId") String productId,
    @Body() Map<String, dynamic> body,
  );
}
