import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ✅ MUST HAVE
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ✅ THIS FIXES ERROR
  );

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
      home: const LoginScreen(),
    );
  }
}
