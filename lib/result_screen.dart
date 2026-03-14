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

  /// Disease descriptions
  String getDiseaseDescription(String disease) {
    switch (disease) {
      case "Cellulitis":
        return "Cellulitis is a bacterial skin infection that causes redness, swelling, warmth and tenderness in the affected area.";

      case "Impetigo":
        return "Impetigo is a contagious bacterial skin infection that causes red sores that burst and form yellowish crusts.";

      case "Athlete’s Foot":
        return "Athlete’s Foot is a fungal infection usually found between the toes causing itching, burning and cracked skin.";

      case "Nail Fungus":
        return "Nail fungus is a fungal infection that makes nails thick, brittle and discolored.";

      case "Ringworm":
        return "Ringworm is a common fungal infection that appears as a circular red rash with clearer skin in the center.";

      case "Cutaneous Larva Migrans":
        return "Cutaneous Larva Migrans is a parasitic infection causing itchy winding red tracks on the skin.";

      case "Chickenpox":
        return "Chickenpox is a viral infection that causes itchy red spots and fluid-filled blisters across the body.";

      case "Shingles":
        return "Shingles is a viral infection that causes a painful rash with blisters, usually appearing on one side of the body.";

      default:
        return "A skin condition has been detected. Please consult a medical professional for confirmation.";
    }
  }

  /// Build Google search query
  String buildSearchQuery(String disease) {
    List<String> keywords = [disease];

    if (answers != null) {
      answers!.forEach((question, answer) {
        if (answer) keywords.add(question);
      });
    }

    keywords.add("skin disease explanation symptoms");

    return keywords.join(" ");
  }

  /// Open browser
  Future<void> openSearch(String query) async {
    final Uri url = Uri.parse(
        "https://www.google.com/search?q=${Uri.encodeComponent(query)}");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  /// Treatment search
  Future<void> openTreatment(String disease) async {
    final Uri url = Uri.parse(
        "https://www.google.com/search?q=${Uri.encodeComponent("$disease skin treatment remedies")}");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  /// Nearby hospitals
  Future<void> openHospitals() async {
    final Uri url = Uri.parse(
        "https://www.google.com/maps/search/dermatology+clinic+near+me");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final String disease = result['topLabel'];
    final double confidence = result['topConfidence'];

    final bool isSkinImage = disease != "Not a skin image";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          /// TOP HEADER
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

                  /// IMAGE
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

                  /// DISEASE NAME
                  Text(
                    disease,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  /// CONFIDENCE
                  Text(
                    "Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// DESCRIPTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      getDiseaseDescription(disease),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  /// WARNING IF NOT SKIN
                  if (!isSkinImage)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        "This image does not appear to be a skin condition. Please upload a clear skin image.",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  if (isSkinImage) ...[
                    const SizedBox(height: 30),

                    /// LEARN MORE
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text("Learn More"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          String query = buildSearchQuery(disease);
                          openSearch(query);
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// TREATMENTS
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.medical_services),
                        label: const Text("Recommended Treatments"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          openTreatment(disease);
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// HOSPITALS
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.local_hospital),
                        label: const Text("Nearby Hospitals"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          openHospitals();
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  /// SCAN AGAIN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Scan Another Image"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
