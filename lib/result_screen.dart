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

  /// ================= DESCRIPTIONS =================
  String getDescription(String disease) {
    switch (disease.trim()) {
      case "Ringworm":
        return "Ringworm is a fungal infection that causes a red, circular rash with clearer skin in the middle. It is often itchy and scaly.";

      case "Cellulitis":
        return "Cellulitis is a bacterial skin infection that causes redness, swelling, warmth, and pain. It can spread quickly and requires medical attention.";

      case "Impetigo":
        return "Impetigo is a contagious bacterial infection that causes red sores and yellowish crusts, commonly around the nose and mouth.";

      case "Athlete’s Foot":
        return "Athlete’s foot is a fungal infection that occurs between the toes, causing itching, burning, and cracked skin.";

      case "Nail Fungus":
        return "Nail fungus causes thick, discolored, and brittle nails. It develops gradually and may spread if untreated.";

      case "Cutaneous Larva Migrans":
        return "This is a parasitic infection that causes winding, snake-like red lines on the skin and intense itching.";

      case "Chickenpox":
        return "Chickenpox is a viral infection that causes itchy, fluid-filled blisters across the body along with fever.";

      case "Shingles":
        return "Shingles is a painful rash caused by reactivation of the chickenpox virus, usually appearing on one side of the body.";

      case "Healthy Skin":
        return "Your skin appears healthy with no visible signs of common skin diseases.";

      case "Healthy or unclear skin condition":
        return "Analysis is unclear or indicates healthy-looking skin. If you see no symptoms, try another image or consult a dermatologist for certainty.";

      case "Not a skin image":
        return "The uploaded image does not appear to be skin. Please upload a clear skin image.";

      default:
        return "No description available.";
    }
  }

  /// ================= SEARCH QUERY =================
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

  /// ================= URL FUNCTIONS =================
  Future<void> openSearch(String query) async {
    final Uri url = Uri.parse(
      "https://www.google.com/search?q=${Uri.encodeComponent(query)}",
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> openTreatment(String disease) async {
    final Uri url = Uri.parse(
      "https://www.google.com/search?q=${Uri.encodeComponent("$disease skin treatment")}",
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> openHospitals() async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/dermatology+clinic+near+me",
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final String disease = result['topLabel'];

    final bool isSkinImage = disease != "Not a skin image";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          /// TOP PURPLE CURVE
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
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  /// CONFIDENCE
                  Text(
                    "Confidence: ${(((result['topConfidence'] as double?) ?? 0.0) * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  /// DESCRIPTION
                  Text(
                    getDescription(disease),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),

                  /// ERROR MESSAGE
                  if (!isSkinImage)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        "Please upload a clear skin image.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  /// BUTTONS (ONLY IF VALID SKIN)
                  if (isSkinImage && disease != "Healthy Skin") ...[
                    const SizedBox(height: 30),

                    /// Learn More
                    ElevatedButton.icon(
                      icon: const Icon(Icons.search),
                      label: const Text("Learn More"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        openSearch(buildSearchQuery(disease));
                      },
                    ),

                    const SizedBox(height: 12),

                    /// Treatment
                    ElevatedButton.icon(
                      icon: const Icon(Icons.medical_services),
                      label: const Text("Recommended Treatments"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        openTreatment(disease);
                      },
                    ),

                    const SizedBox(height: 12),

                    /// Hospitals
                    ElevatedButton.icon(
                      icon: const Icon(Icons.local_hospital),
                      label: const Text("Nearby Hospitals"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        openHospitals();
                      },
                    ),
                  ],

                  const SizedBox(height: 20),

                  /// SCAN AGAIN
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Scan Another Image"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
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
