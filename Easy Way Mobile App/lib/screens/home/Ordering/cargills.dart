import 'package:firebase/screens/home/Ordering/add_cart.dart';
import 'package:firebase/screens/home/Ordering/shop.dart';
import 'package:firebase/screens/home/home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CargillsOrderPage extends StatefulWidget {
  @override
  _CargillsOrderPageState createState() => _CargillsOrderPageState();
}

class _CargillsOrderPageState extends State<CargillsOrderPage> {
  final List<Map<String, dynamic>> goods = [
    {'name': 'Coffee', 'price': 300, 'image': 'assets/images/coffe.jpg'},
    {'name': 'Burger', 'price': 500, 'image': 'assets/images/buger.jpg'},
    {'name': 'Sandwich', 'price': 450, 'image': 'assets/images/sandwitch.jpg'},
    {'name': 'Juice', 'price': 250, 'image': 'assets/images/juice.jpg'},
    {'name': 'Water Bottle', 'price': 150, 'image': 'assets/images/water.jpg'},
    {'name': 'Tissue Box', 'price': 170, 'image': 'assets/images/tissue.png'},
    {'name': 'Chips', 'price': 180, 'image': 'assets/images/chips.jpg'},
    {'name': 'Milk', 'price': 170, 'image': 'assets/images/milk.jpg'},
    {'name': 'Soda', 'price': 175, 'image': 'assets/images/soda.png'},
  ];

  final List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      // Prevent adding duplicates to the cart
      if (!cart.any((element) => element['name'] == item['name'])) {
        cart.add(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item['name']} added to cart!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item['name']} is already in the cart!')),
        );
      }
    });
  }

  double calculateTotal() {
    return cart.fold(0, (total, item) => total + item['price']);
  }

  void goToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cart: cart, total: calculateTotal(), description: '',),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Shop Now', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ShoppingCenterPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: goToCartPage,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[900]!, Colors.orange[400]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/foodcity.png', 
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Cargills Food City',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "     Fresh groceries and household items.",
                style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
              ),
              SizedBox(height: 15),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: goods.length,
                  itemBuilder: (context, index) {
                    final item = goods[index];
                    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.asset(
                                item['image'],
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['name'],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '\RS.${item['price']}',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => addToCart(item),
                              child: Text('Add to Cart'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                elevation: 4,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
