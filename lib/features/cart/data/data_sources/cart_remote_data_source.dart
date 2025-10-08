import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:laza/features/cart/data/models/cart_response_model.dart';

part 'cart_remote_data_source.g.dart';

@RestApi()
abstract class CartRemoteDataSource {
  factory CartRemoteDataSource(Dio dio, {String baseUrl}) =
      _CartRemoteDataSource;

  @GET('cart')
  Future<CartResponseModel> getCartItems();

  @POST('cart/items')
  Future<void> addToCart(@Body() Map<String, dynamic> body);

  @DELETE('cart/items/{id}')
  Future<void> removeFromCart(@Path('id') String id);

  @PUT('cart/items/{id}')
  Future<void> updateQuantity(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('cart/items/decrement')
  Future<void> decrementQuantity(@Body() Map<String, dynamic> body);

  @DELETE('cart')
  Future<void> clearCart();
}
