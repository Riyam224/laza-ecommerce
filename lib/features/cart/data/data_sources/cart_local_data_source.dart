

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laza/features/cart/data/models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(CartItemModel item);
  Future<void> removeFromCart(String itemId);
  Future<void> updateQuantity(String itemId, int quantity);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cartKey = 'CACHED_CART_ITEMS';

  CartLocalDataSourceImpl({required this.sharedPreferences});

  // 🧾 Load cart items
  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final jsonString = sharedPreferences.getString(cartKey);

      if (jsonString == null || jsonString.isEmpty) {
        print('🛒 No saved cart found → returning empty list');
        return [];
      }

      final List decoded = json.decode(jsonString);
      final List<CartItemModel> items = decoded
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList();

      print(' Loaded ${items.length} items from local cart');
      return items;
    } catch (e) {
      print('❌ Error reading cart: $e → Resetting cart');
      await sharedPreferences.remove(cartKey);
      return [];
    }
  }

  // ➕ Add new or update existing item
  @override
  Future<void> addToCart(CartItemModel item) async {
    final items = await getCartItems();

    final index = items.indexWhere((i) => i.productId == item.productId);
    if (index != -1) {
      final existing = items[index];
      items[index] = existing.copyWith(
        quantity: existing.quantity + item.quantity,
      );
      print(
        ' Updated ${existing.productName} → qty ${items[index].quantity}',
      );
    } else {
      items.add(item);
      print(' Added new item → ${item.productName}');
    }

    await _saveItems(items);
  }

  // 🗑️ Remove item by ID
  @override
  Future<void> removeFromCart(String itemId) async {
    final items = await getCartItems();
    items.removeWhere((item) => item.id == itemId);
    await _saveItems(items);
    print('🗑️ Removed item → $itemId');
  }

  // 🔄 Update item quantity
  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    final items = await getCartItems();
    final index = items.indexWhere((item) => item.id == itemId);

    if (index != -1) {
      if (quantity <= 0) {
        items.removeAt(index);
        print('🚫 Removed item → $itemId (quantity 0)');
      } else {
        items[index] = items[index].copyWith(quantity: quantity);
        print('🔄 Updated ${items[index].productName} → qty $quantity');
      }
      await _saveItems(items);
    }
  }

  // 🧹 Clear cart
  @override
  Future<void> clearCart() async {
    await sharedPreferences.remove(cartKey);
    print('🧹 Cart cleared');
  }

  // 💾 Save updated cart
  Future<void> _saveItems(List<CartItemModel> items) async {
    final jsonList = items.map((e) => e.toJson()).toList();
    await sharedPreferences.setString(cartKey, json.encode(jsonList));
    print('💾 Saved ${items.length} items locally');
  }
}
