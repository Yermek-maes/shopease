import 'package:flutter/material.dart';
import '../repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  final List<Map<String, dynamic>> _products = [];

  List<Map<String, dynamic>> get products => [..._products];

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await _repository.fetchProducts();
      _products.clear();
      _products.addAll(fetchedProducts);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}
