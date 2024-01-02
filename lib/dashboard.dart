import 'package:flutter/material.dart';
import 'package:rezzer/resolutions.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Resolutions(),
    );
  }
}
