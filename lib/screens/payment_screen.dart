import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController(); // Контроллер для номера карты.
  final _cardHolderController = TextEditingController(); // Контроллер для имени владельца карты.
  final _expiryDateController = TextEditingController(); // Контроллер для срока действия карты.
  final _cvvController = TextEditingController(); // Контроллер для CVV кода.
  final _formKey = GlobalKey<FormState>(); // Ключ формы для валидации.
  bool _isProcessing = false; // Флаг состояния обработки оплаты.

  // Метод для обработки платежа.
  void _processPayment() async {
    if (_formKey.currentState!.validate()) { // Проверка валидности формы.
      setState(() {
        _isProcessing = true; // Установка состояния обработки.
      });
      await Future.delayed(Duration(seconds: 2)); // Имитация задержки для обработки.
      setState(() {
        _isProcessing = false; // Сброс состояния обработки.
      });

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Payment Successful'), // Сообщение об успешной оплате.
          content: Text('Your payment has been processed successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context); // Закрытие экрана оплаты.
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'), // Заголовок экрана оплаты.
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Привязка формы к ключу.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter Payment Details', // Заголовок формы.
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _cardNumberController, // Поле ввода номера карты.
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your card number.'; // Проверка на пустое значение.
                    } else if (value.length < 16) {
                      return 'Card number must be 16 digits.'; // Проверка длины номера карты.
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _cardHolderController, // Поле ввода имени владельца карты.
                  decoration: InputDecoration(
                    labelText: 'Card Holder Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the card holder name.'; // Проверка на пустое значение.
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryDateController, // Поле ввода срока действия карты.
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter expiry date.'; // Проверка на пустое значение.
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController, // Поле ввода CVV кода.
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter CVV.'; // Проверка на пустое значение.
                          } else if (value.length != 3) {
                            return 'CVV must be 3 digits.'; // Проверка длины CVV.
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _isProcessing
                    ? Center(child: CircularProgressIndicator()) // Индикатор обработки.
                    : ElevatedButton(
                        onPressed: _processPayment, // Кнопка для обработки платежа.
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Pay Now',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
