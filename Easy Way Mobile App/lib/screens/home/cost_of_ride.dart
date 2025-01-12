import 'package:flutter/material.dart';
import 'package:firebase/screens/home/Paymnts.dart';

class CostPage extends StatelessWidget {
  final String qrCode; // Entrance QR code
  final String exitQrCode; // Exit QR code

  CostPage({
    required this.qrCode,
    required this.exitQrCode,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the total price based on the QR code values
    double? totalPrice;
    if ((qrCode == 'Maththala' || qrCode == 'Matara') && exitQrCode.isNotEmpty) {
      totalPrice = 500;
    } else if ((qrCode == 'Kottawa' || qrCode == 'Matara') && exitQrCode.isNotEmpty) {
      totalPrice = 1300;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cost of Ride', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF5722), Color(0xFFFFA726)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Entrance QR Code: $qrCode',
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 20),
              Text('Exit QR Code: $exitQrCode',
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 20),
              Text(
                'Total Price: LKR ${totalPrice != null ? totalPrice.toString() : 'Unknown'}',
                style: const TextStyle(
                    fontSize: 33, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
            ElevatedButton(
                onPressed: totalPrice != null
                    ? () {
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(
                              totalCost: totalPrice!,
                              details: "Ride",  // Pass "Ride" here
                              description: '',  // Optionally leave description empty or add another value
                            ),
                          ),
                        );
                      }
                    : null, // Disable button if totalPrice is null
                child: const Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
