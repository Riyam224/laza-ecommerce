import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:laza/features/cart/data/models/cart_response_model.dart';

part 'cart_api_service.g.dart';

@RestApi()
abstract class CartApiService {
  factory CartApiService(Dio dio, {String baseUrl}) = _CartApiService;

  // ✅ FIX: The API returns a CartResponseModel, not a list
  @GET('/api/cart')
  Future<CartResponseModel> getCart();

  @POST('/api/cart/items')
  Future<void> addToCart(@Body() Map<String, dynamic> body);

  @DELETE('/api/cart/items/{id}')
  Future<void> removeFromCart(@Path('id') String id);

  @PUT('/api/cart/items/{id}')
  Future<void> updateQuantity(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/api/cart')
  Future<void> clearCart();
}
