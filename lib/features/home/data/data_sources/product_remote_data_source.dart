import 'package:dio/dio.dart';
import 'package:laza/core/networking/api_constants.dart';
import 'package:laza/features/home/data/models/category_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:laza/features/home/data/models/product_model.dart';

part 'product_remote_data_source.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ProductRemoteDataSource {
  factory ProductRemoteDataSource(Dio dio, {String baseUrl}) =
      _ProductRemoteDataSource;

  //  FIXED return type
  @GET("products")
  Future<HttpResponse<dynamic>> getProducts(
    @Queries() Map<String, dynamic> queries,
  );

  @GET("products/{id}")
  Future<ProductModel> getProductById(@Path("id") String id);

  @GET('reviews/{productId}')
  Future<HttpResponse<dynamic>> getReviews(
    @Path('productId') String productId,
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );
  @POST("reviews/{productId}")
  Future<void> addReview(
    @Path("productId") String productId,
    @Body() Map<String, dynamic> body,
  );

  @GET("categories")
  Future<CategoryResponse> getCategories();

  @GET("products")
  Future<HttpResponse<dynamic>> getProductsByCategory(
    @Query("categoryId") String categoryId,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
  );
}
