// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:laza/features/cart/data/models/cart_item_model.dart';

// abstract class CartLocalDataSource {
//   Future<List<CartItemModel>> getCartItems();
//   Future<void> addToCart(CartItemModel item);
//   Future<void> removeFromCart(String itemId);
//   Future<void> updateQuantity(String itemId, int quantity);
//   Future<void> clearCart();
// }

// class CartLocalDataSourceImpl implements CartLocalDataSource {
//   final SharedPreferences sharedPreferences;
//   static const String cartKey = 'CACHED_CART_ITEMS';

//   CartLocalDataSourceImpl({required this.sharedPreferences});

//   @override
//   Future<List<CartItemModel>> getCartItems() async {
//     final jsonString = sharedPreferences.getString(cartKey);
//     if (jsonString != null) {
//       final List<dynamic> jsonList = json.decode(jsonString);
//       return jsonList.map((json) => CartItemModel.fromJson(json)).toList();
//     }
//     return [];
//   }

//   @override
//   Future<void> addToCart(CartItemModel item) async {
//     final items = await getCartItems();

//     // Check if item already exists
//     final existingIndex = items.indexWhere(
//       (i) => i.productId == item.productId,
//     );

//     if (existingIndex != -1) {
//       // Update quantity if item exists
//       items[existingIndex] = CartItemModel(
//         id: items[existingIndex].id,
//         productId: items[existingIndex].productId,
//         productName: items[existingIndex].productName,
//         productImage: items[existingIndex].productImage,
//         price: items[existingIndex].price,
//         tax: items[existingIndex].tax,
//         quantity: items[existingIndex].quantity + item.quantity,
//       );
//     } else {
//       items.add(item);
//     }

//     await _saveItems(items);
//   }

//   @override
//   Future<void> removeFromCart(String itemId) async {
//     final items = await getCartItems();
//     items.removeWhere((item) => item.id == itemId);
//     await _saveItems(items);
//   }

//   @override
//   Future<void> updateQuantity(String itemId, int quantity) async {
//     final items = await getCartItems();
//     final index = items.indexWhere((item) => item.id == itemId);

//     if (index != -1) {
//       if (quantity <= 0) {
//         items.removeAt(index);
//       } else {
//         items[index] = CartItemModel(
//           id: items[index].id,
//           productId: items[index].productId,
//           productName: items[index].productName,
//           productImage: items[index].productImage,
//           price: items[index].price,
//           tax: items[index].tax,
//           quantity: quantity,
//         );
//       }
//       await _saveItems(items);
//     }
//   }

//   @override
//   Future<void> clearCart() async {
//     await sharedPreferences.remove(cartKey);
//   }

//   Future<void> _saveItems(List<CartItemModel> items) async {
//     final jsonList = items.map((item) => item.toJson()).toList();
//     await sharedPreferences.setString(cartKey, json.encode(jsonList));
//   }
// }

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

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final jsonString = sharedPreferences.getString(cartKey);

      if (jsonString == null || jsonString.isEmpty) {
        // 🟣 Debug log (optional)
        print('🛒 No saved cart found, returning empty list');
        return [];
      }

      final decoded = json.decode(jsonString);
      if (decoded is! List) {
        print('⚠️ Invalid cart data format — resetting cart');
        await sharedPreferences.remove(cartKey);
        return [];
      }

      final List<CartItemModel> items = decoded
          .map((json) => CartItemModel.fromJson(json))
          .cast<CartItemModel>()
          .toList();

      print('📦 Loaded ${items.length} items from local cart');
      return items;
    } catch (e) {
      print('❌ Error reading cart: $e');
      await sharedPreferences.remove(cartKey); // reset corrupted data
      return [];
    }
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    final items = await getCartItems();

    final existingIndex = items.indexWhere(
      (i) => i.productId == item.productId,
    );

    if (existingIndex != -1) {
      // ✅ If product exists → update quantity
      final existing = items[existingIndex];
      items[existingIndex] = existing.copyWith(
        quantity: existing.quantity + item.quantity,
      );
      print(
        '🔁 Updated ${existing.productName} quantity → ${items[existingIndex].quantity}',
      );
    } else {
      items.add(item);
      print('➕ Added new item: ${item.productName}');
    }

    await _saveItems(items);
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    final items = await getCartItems();
    items.removeWhere((item) => item.id == itemId);
    await _saveItems(items);
    print('🗑️ Removed item with id: $itemId');
  }

  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    final items = await getCartItems();
    final index = items.indexWhere((item) => item.id == itemId);

    if (index != -1) {
      if (quantity <= 0) {
        items.removeAt(index);
        print('🚫 Removed item with id: $itemId (quantity 0)');
      } else {
        items[index] = items[index].copyWith(quantity: quantity);
        print('🔄 Updated item ${items[index].productName} → qty: $quantity');
      }
      await _saveItems(items);
    }
  }

  @override
  Future<void> clearCart() async {
    await sharedPreferences.remove(cartKey);
    print('🧹 Cart cleared');
  }

  Future<void> _saveItems(List<CartItemModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await sharedPreferences.setString(cartKey, json.encode(jsonList));
    print('💾 Saved ${items.length} items to local cart');
  }
}
