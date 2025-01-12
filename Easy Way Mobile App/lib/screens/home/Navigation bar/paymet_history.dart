import 'package:firebase/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import FirebaseAuth
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PaymentHistoryPage extends StatelessWidget {
  // Reference to the 'payments' node in Firebase Realtime Database
  final DatabaseReference _paymentsRef = FirebaseDatabase.instance.ref().child('payments');

  @override
  Widget build(BuildContext context) {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    
    // Check if the user is authenticated
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Payment History"),
        ),
        body: const Center(
          child: Text("Please log in to view payment history."),
        ),
      );
    }

    // Reference to the user's specific payments using their UID
    final userPaymentsRef = _paymentsRef.child(user.uid);

    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind the app bar to remove the white bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate to the Home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900]!,
              Colors.orange[800]!,
              Colors.orange[400]!,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "     Payment History",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "          View Your Payment Transactions",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: StreamBuilder(
                  stream: userPaymentsRef.onValue, // Listen to value changes in the user's payments node
                  builder: (context, snapshot) {
                    // If waiting for data, show a loading indicator
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // If error occurred, display the error
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    // If no data available, show a customized message
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text(
                          "You are not using our app. No payment history found.",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      );
                    }

                    // Get data from the snapshot safely
                    final data = snapshot.data as DatabaseEvent;
                    final Map<dynamic, dynamic>? paymentsData =
                        data.snapshot.value as Map<dynamic, dynamic>?;

                    // Check if paymentsData is null
                    if (paymentsData == null) {
                      return const Center(
                        child: Text(
                          "No payment data available",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      );
                    }

                    // Prepare the list of payment details
                    List<Map<String, String>> payments = [];
                    paymentsData.forEach((key, value) {
                      payments.add({
                        'cost': 'LKR ${value['cost'] ?? '0'}',
                        'payment_date': value['payment_date'] ?? 'Unknown Date',
                        'payment_method': value['payment_method'] ?? 'Unknown',
                        'details':value['details'] ?? 'Unknow',
                      });
                    });

                    // Return a ListView of payment cards
                    return ListView.builder(
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        return PaymentCard(
                          date: payments[index]['payment_date']!,
                          amount: payments[index]['cost']!,
                          status: payments[index]['payment_method']!,
                          details: payments[index]['details']!,
                          
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final String date;
  final String amount;
  final String status;
  final String details;

  const PaymentCard({
    super.key,
    required this.date,
    required this.amount,
    required this.status,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side with payment details (date, amount, method, details)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  amount,
                  style: TextStyle(fontSize: 18, color: Colors.orange[900]),
                ),
                const SizedBox(height: 10),
                Text(
                  "Details: $details", // Displaying additional details
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ],
            ),
            // Right side displaying the payment method in a colored container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: status == 'Card' ? Colors.green : (status == 'Cash' ? Colors.green : Colors.red),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }  
}
