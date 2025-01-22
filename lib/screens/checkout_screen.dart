import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartItems = [
      {'title': 'Product 1', 'price': 29.99}, // Пример товара в корзине.
      {'title': 'Product 2', 'price': 49.99}, // Пример второго товара в корзине.
    ];
    final totalAmount = cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] as double), // Вычисление общей суммы.
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'), // Заголовок экрана оформления заказа.
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Order Summary', // Заголовок раздела сводки заказа.
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length, // Количество товаров в корзине.
                itemBuilder: (context, index) {
                  final item = cartItems[index]; // Текущий товар.
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        item['title'].toString(), // Название товара.
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '\$${(item['price'] as double).toStringAsFixed(2)}', // Цена товара.
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(thickness: 2), // Разделительная линия.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:', // Метка для итоговой суммы.
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}', // Итоговая сумма.
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Логика завершения покупки (не реализована).
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Complete Purchase', // Текст на кнопке завершения покупки.
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
