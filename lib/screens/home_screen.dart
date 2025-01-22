// Добавление подробных комментариев ко всем предоставленным Dart файлам для лучшего понимания и подготовки к экзамену.

// Файл: cart_provider.dart

// Этот файл содержит провайдер для управления состоянием корзины в приложении.
// Включает функционал для добавления, удаления и обновления товаров в корзине.

// Файл: product_provider.dart

// Этот файл предоставляет управление состоянием для данных о продуктах.
// Включает получение данных о продуктах из репозитория, кэширование и фильтрацию.

// Файл: auth_provider.dart

// Этот файл управляет состоянием аутентификации, включая вход, выход и управление сессиями пользователей.
// Также обрабатывает взаимодействие с API и сервисами аутентификации.

// Файл: product_repository.dart

// Этот файл служит слоем абстракции для доступа к данным о продуктах.
// Получает информацию о продуктах из API или локальных источников данных и предоставляет их провайдерам.

// Файл: home_screen.dart

// Этот файл представляет главный экран приложения.
// Содержит компоненты интерфейса для отображения избранных продуктов, категорий и навигации.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

// Основной экран приложения с отображением продуктов и навигацией.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = false; // Состояние загрузки для отображения индикатора.
  String _searchQuery = ''; // Текущий поисковый запрос пользователя.

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Получение продуктов при инициализации.
  }

  // Метод для получения данных о продуктах из провайдера.
  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true; // Установка состояния загрузки.
    });
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    setState(() {
      _isLoading = false; // Сброс состояния загрузки.
    });
  }

  // Метод для проверки авторизации перед выполнением действия.
  void _requireLogin(BuildContext context, VoidCallback onAuthorized) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Authentication Required'),
          content: Text('Please log in or create an account to proceed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      );
    } else {
      onAuthorized();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'), // Заголовок приложения.
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search), // Кнопка для поиска продуктов.
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(productProvider: productProvider),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart), // Переход в корзину.
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: Icon(Icons.person), // Переход в профиль.
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Отображение загрузочного индикатора.
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: productProvider.products.length,
                itemBuilder: (ctx, i) {
                  final product = productProvider.products[i];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              product['image'], // Изображение продукта.
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product['title'], // Название продукта.
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '\$${product['price']}', // Цена продукта.
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _requireLogin(context, () {
                                cartProvider.addToCart({
                                  'id': product['id'],
                                  'price': product['price'],
                                  'title': product['title'],
                                  'quantity': 1,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added to cart!'),
                                  ),
                                );
                              });
                            },
                            child: Text('Add to Cart'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

// Класс для реализации поиска продуктов.
class ProductSearchDelegate extends SearchDelegate {
  final ProductProvider productProvider;

  ProductSearchDelegate({required this.productProvider});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear), // Очистить строку поиска.
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back), // Кнопка назад.
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = productProvider.products
        .where((product) => product['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (ctx, i) => ListTile(
        title: Text(results[i]['title']),
        subtitle: Text('\$${results[i]['price']}'),
        onTap: () {
          close(context, results[i]);
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = productProvider.products
        .where((product) => product['title'].toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (ctx, i) => ListTile(
        title: Text(suggestions[i]['title']),
        onTap: () {
          query = suggestions[i]['title'];
          showResults(context);
        },
      ),
    );
  }
}
