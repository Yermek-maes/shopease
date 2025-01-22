import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _orderHistory = [
    {
      'orderId': '12345',
      'date': '2025-01-01',
      'total': 59.99,
      'items': [
        {'title': 'Product 1', 'price': 29.99},
        {'title': 'Product 2', 'price': 30.00},
      ],
    },
    {
      'orderId': '67890',
      'date': '2025-01-15',
      'total': 99.99,
      'items': [
        {'title': 'Product 3', 'price': 50.00},
        {'title': 'Product 4', 'price': 49.99},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userEmail = authProvider.user?.email ?? 'Unknown User';

    if (authProvider.user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Order History'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                'Please log in to view your order history.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Order history for $userEmail',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _orderHistory.length,
                itemBuilder: (context, index) {
                  final order = _orderHistory[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        'Order #${order['orderId']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Date: ${order['date']}\nTotal: \$${order['total'].toStringAsFixed(2)}'),
                      isThreeLine: true,
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Navigate to order details screen (not implemented)
                        },
                        child: Text('View Details'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}