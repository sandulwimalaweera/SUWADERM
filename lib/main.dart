import 'package:flutter/material.dart';
import 'skin_capture_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SkinDiseaseApp());
}

class SkinDiseaseApp extends StatelessWidget {
  const SkinDiseaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skin Disease Identifier',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const SkinCaptureScreen(),
    );
  }
}
