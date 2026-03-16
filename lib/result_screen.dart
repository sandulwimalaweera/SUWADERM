import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'skin_capture_screen.dart';

class ResultScreen extends StatelessWidget {
  final File image;
  final Map<String, dynamic> result;
  final Map<String, bool>? answers;

  const ResultScreen({
    super.key,
    required this.image,
    required this.result,
    this.answers,
  });

  String buildSearchQuery(String disease) {
    List<String> keywords = [disease];

    if (answers != null) {
      answers!.forEach((question, answer) {
        if (answer) keywords.add(question);
      });
    }

    keywords.add("skin disease symptoms treatment");

    return keywords.join(" ");
  }

  Future<void> openSearch(String query) async {
    final Uri url = Uri.parse(
        "https://www.google.com/search?q=${Uri.encodeComponent(query)}");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> openTreatment(String disease) async {
    final Uri url = Uri.parse(
        "https://www.google.com/search?q=${Uri.encodeComponent("$disease skin treatment")}");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> openHospitals() async {
    final Uri url = Uri.parse(
        "https://www.google.com/maps/search/dermatology+clinic+near+me");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final String disease = result['topLabel'];
    final double confidence = result['topConfidence'];

    String message;

    if (disease == "Not a skin image") {
      message = "This image does not appear to be skin.";
    } else if (disease == "Healthy Skin") {
      message = "Your skin appears healthy. No visible skin disease detected.";
    } else {
      message =
          "A skin condition has been detected. Please consult a medical professional for confirmation.";
    }

    final bool isSkinImage = disease != "Not a skin image";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Container(
            height: 240,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Diagnosis Result",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    disease,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  if (!isSkinImage)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        "This image does not appear to be a skin condition.\nPlease upload a clear skin image.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (isSkinImage && disease != "Healthy Skin") ...[
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text("Learn More"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          String query = buildSearchQuery(disease);
                          openSearch(query);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.medical_services),
                        label: const Text("Recommended Treatments"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          openTreatment(disease);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.local_hospital),
                        label: const Text("Nearby Hospitals"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          openHospitals();
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Scan Another Image"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SkinCaptureScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
