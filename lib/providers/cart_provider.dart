import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];
  final List<Map<String, dynamic>> _orderHistory = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;
  List<Map<String, dynamic>> get orderHistory => _orderHistory;

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item['price'] as double));
  }

  void addToCart(Map<String, dynamic> product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void placeOrder() {
    final order = {
      'orderId': DateTime.now().millisecondsSinceEpoch.toString(),
      'date': DateTime.now().toIso8601String(),
      'total': totalPrice,
      'items': List<Map<String, dynamic>>.from(_cartItems),
    };
    _orderHistory.add(order);
    clearCart();
    notifyListeners();
  }
}
