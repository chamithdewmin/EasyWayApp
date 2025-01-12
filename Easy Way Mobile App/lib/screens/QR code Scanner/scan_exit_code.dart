import 'package:firebase/screens/home/cost_of_ride.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class HighwayExitCodeScanScreen extends StatelessWidget {
  final String entranceQrCode;
  final String exitQrCode;

  HighwayExitCodeScanScreen({required this.exitQrCode, required this.entranceQrCode, required String qrCode});

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
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Title
              Text(
                'Highway Exit\nCode Scan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              // Description
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
              SizedBox(height: size.height * 0.05),
              // Entrance QR Code display
              Text(
                'Entrance QR Code: ${entranceQrCode.isNotEmpty ? entranceQrCode : "Loading..."}',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 0),
              Spacer(),
              // QR Code Scanner
              Stack(
                alignment: Alignment.center,
                children: [
                  // Mobile Scanner
                  Positioned.fill(
                    child: MobileScanner(
                      controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.noDuplicates, // Changed detection speed
                      ),
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;

                        for (final barcode in barcodes) {
                          final exitQrCode = barcode.rawValue;
                          if (exitQrCode != null) {
                            // Navigate to the CostPage, passing both entranceQrCode and exitQrCode
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CostPage(
                                qrCode: entranceQrCode,
                                exitQrCode: exitQrCode,
                              ),
                            ),
                          );

                            break; // Exit loop after first valid QR code detection
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
