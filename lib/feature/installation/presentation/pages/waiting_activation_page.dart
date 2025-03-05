import 'package:flutter/material.dart';

class WaitingActivationPage extends StatelessWidget {
  final String deviceId;

  WaitingActivationPage({required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Waiting for Activation', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Device ID: $deviceId'),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}