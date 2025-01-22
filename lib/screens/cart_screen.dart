import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context); // Получение состояния корзины из провайдера.
    final cartItems = cart.cartItems; // Список товаров в корзине.

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'), // Заголовок экрана корзины.
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length, // Количество товаров в корзине.
              itemBuilder: (ctx, i) => Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FittedBox(
                        child: Text('\$${cartItems[i]['price']}'), // Цена одного товара.
                      ),
                    ),
                  ),
                  title: Text(cartItems[i]['title']), // Название товара.
                  subtitle: Text(
                      'Total: \$${(cartItems[i]['price'] * cartItems[i]['quantity']).toStringAsFixed(2)}'), // Общая стоимость товара с учетом количества.
                  trailing: Text('${cartItems[i]['quantity']}x'), // Количество единиц товара.
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:', // Метка для общей суммы.
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}', // Общая сумма товаров в корзине.
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/payment'); // Переход на экран оплаты.
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    'Proceed to Checkout', // Текст на кнопке перехода к оплате.
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
