import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:laza/features/home/data/models/product_model.dart';
import 'package:laza/features/home/data/models/review_model.dart';

part 'product_remote_data_source.g.dart';

@RestApi(baseUrl: "https://accessories-eshop.runasp.net/api/")
abstract class ProductRemoteDataSource {
  factory ProductRemoteDataSource(Dio dio, {String baseUrl}) =
      _ProductRemoteDataSource;

  // ✅ FIXED return type
  @GET("products")
  Future<HttpResponse<dynamic>> getProducts(
    @Queries() Map<String, dynamic> queries,
  );

  @GET("products/{id}")
  Future<ProductModel> getProductById(@Path("id") String id);

  @GET("reviews/{productId}")
  Future<List<ReviewModel>> getReviews(@Path("productId") String productId);

  @POST("reviews/{productId}")
  Future<void> addReview(
    @Path("productId") String productId,
    @Body() Map<String, dynamic> body,
  );
}
