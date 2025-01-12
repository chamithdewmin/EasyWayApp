import 'package:firebase/screens/home/Paymnts.dart';
import 'package:flutter/material.dart';


class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final String description;

  CartPage({required this.cart, required double total, required this.description});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(int index) {
    setState(() {
      widget.cart.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item removed from cart!')),
    );
  }

  double calculateTotal() {
    return widget.cart.fold(0, (total, item) => total + item['price']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.orange,
      ),
      body: widget.cart.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final item = widget.cart[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('\RS.${item['price'].toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => removeFromCart(index),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        color: Colors.orange,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: \RS.${calculateTotal().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: widget.cart.isEmpty
                  ? null
                  : () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            totalCost: calculateTotal(),
                            details: "Order",  // Pass "Order" here
                            description: "Order",  // Description can also be passed here
                          ),
                        ),
                      );
                    },
              child: Center(child: Text('Place Order')),
            ),
          ],
        ),
      ),
    );
  }
} 