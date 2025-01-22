import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductRepository {
  final String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) {
          return {
            'id': item['id'],
            'title': item['title'],
            'price': item['price'],
            'description': item['description'],
            'image': item['image'],
            'category': item['category'],
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
