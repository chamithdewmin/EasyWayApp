import 'dart:typed_data';
import 'package:firebase/screens/home/home.dart';
import 'package:firebase/screens/home/maps/map.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class HighwayEntranceCodeScanScreen extends StatelessWidget {
  final String qrCode;

  HighwayEntranceCodeScanScreen({required this.qrCode});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double boxSize = size.width * 0.8;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF5722), Color(0xFFFFA726)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Title
              Text(
                'Highway Entrance\nCode Scan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: size.height * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                'Place the QR code inside the box to scan and access the highway entrance. '
                'Ensure the code is clear and within the frame for accurate detection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: size.width * 0.035,
                color: Colors.white,
                ),
              ),
            ),


              SizedBox(height: size.height * 0.01),
              Spacer(),
              // QR Code Scanner
              Stack(
                alignment: Alignment.center,
                children: [
                  // Camera Feed
                  Positioned.fill(
                    child: MobileScanner(
                      controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.noDuplicates,
                      ),
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          if (barcode.rawValue != null) {
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                             builder: (context) => MapPage(
                             qrCode: barcode.rawValue!, entranceQrCode: '', // Passing the QR code to MapPage
                             ),
                           ),
                          );
                          }
                        }
                      },
                    ),
                   ),
                  // Scanning Box
                  Container(
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
