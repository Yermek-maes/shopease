import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(); // Контроллер для поля ввода email.
  final _passwordController = TextEditingController(); // Контроллер для поля ввода пароля.
  final _formKey = GlobalKey<FormState>(); // Ключ формы для валидации.
  bool _isLoading = false; // Флаг состояния загрузки.

  // Метод для выполнения авторизации.
  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) { // Проверка валидности формы.
      setState(() {
        _isLoading = true; // Установка состояния загрузки.
      });
      try {
        // Попытка выполнить вход через провайдер авторизации.
        final success = await Provider.of<AuthProvider>(context, listen: false)
            .login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (success) {
          Navigator.pushReplacementNamed(context, '/'); // Успешный вход, переход на главный экран.
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid email or password')), // Ошибка входа.
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $error')), // Ошибка во время запроса.
        );
      } finally {
        setState(() {
          _isLoading = false; // Сброс состояния загрузки.
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'), // Заголовок экрана входа.
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
                  'Welcome Back!', // Приветственное сообщение.
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController, // Поле ввода email.
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress, // Тип клавиатуры для email.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.'; // Проверка на пустое значение.
                    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+\$').hasMatch(value)) {
                      return 'Enter a valid email.'; // Проверка формата email.
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController, // Поле ввода пароля.
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true, // Скрытие текста для пароля.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.'; // Проверка на пустое значение.
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _isLoading
                    ? Center(child: CircularProgressIndicator()) // Индикатор загрузки.
                    : ElevatedButton(
                        onPressed: () => _login(context),
                        child: Text('Login'), // Кнопка входа.
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register'); // Переход на экран регистрации.
                  },
                  child: Text('Don’t have an account? Register here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
