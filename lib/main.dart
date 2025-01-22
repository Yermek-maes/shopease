import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/payment_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Инициализация привязок Flutter.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Настройка Firebase для текущей платформы.
  );

  final authProvider = AuthProvider(); // Создание провайдера авторизации.
  await authProvider.initializeUser(); // Инициализация текущего пользователя.

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()), // Провайдер состояния корзины.
        ChangeNotifierProvider(create: (_) => ProductProvider()), // Провайдер данных о продуктах.
        ChangeNotifierProvider(create: (_) => authProvider), // Провайдер авторизации.
      ],
      child: MyApp(),
    ),
  );
}

// Основной виджет приложения.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Доступ к состоянию авторизации.

    return MaterialApp(
      debugShowCheckedModeBanner: false, // Отключение баннера режима отладки.
      theme: ThemeData(
        primarySwatch: Colors.blue, // Основная цветовая схема.
        visualDensity: VisualDensity.adaptivePlatformDensity, // Адаптивная плотность интерфейса.
      ),
      initialRoute: '/', // Начальный маршрут приложения.
      routes: {
        '/': (context) => authProvider.isAuthenticated ? HomeScreen() : LoginScreen(), // Проверка аутентификации для маршрута.
        '/login': (context) => LoginScreen(), // Экран входа.
        '/register': (context) => RegisterScreen(), // Экран регистрации.
        '/cart': (context) => CartScreen(), // Экран корзины.
        '/checkout': (context) => CheckoutScreen(), // Экран оформления заказа.
        '/profile': (context) => ProfileScreen(), // Экран профиля пользователя.
        '/order_history': (context) => OrderHistoryScreen(), // Экран истории заказов.
        '/payment': (context) => PaymentScreen(), // Экран оплаты.
      },
    );
  }
}

