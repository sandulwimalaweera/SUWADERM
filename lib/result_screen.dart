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

  /// Build Google search query
  String buildSearchQuery(String disease) {
    List<String> keywords = [disease];

    if (answers != null) {
      answers!.forEach((question, answer) {
        if (answer) {
          keywords.add(question);
        }
      });
    }

    keywords.add("skin condition explanation symptoms treatment");

    return keywords.join(" ");
  }

  /// Open Google Search
  Future<void> openSearch(String query) async {
    final Uri url = Uri.parse(
        "https://www.google.com/search?q=${Uri.encodeComponent(query)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Treatment search
  Future<void> openTreatment(String disease) async {
    final Uri url = Uri.parse(
        "https://www.google.com/search?q=${Uri.encodeComponent("$disease skin treatment causes remedies")}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Explanation popup
  void showExplanation(BuildContext context, String disease) {
    List<String> positiveSymptoms = [];

    if (answers != null) {
      answers!.forEach((question, answer) {
        if (answer) positiveSymptoms.add(question);
      });
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Why this result?"),
        content: positiveSymptoms.isEmpty
            ? const Text(
                "The prediction was based mainly on image analysis. No symptoms were confirmed in the questionnaire.",
                style: TextStyle(fontSize: 14),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "The system predicted \"$disease\" because the following symptoms were confirmed:",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ...positiveSymptoms.map(
                    (s) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.check, color: Colors.green),
                          const SizedBox(width: 6),
                          Expanded(child: Text(s)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String disease = result['topLabel'];
    final double confidence = result['topConfidence'];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          /// TOP CURVE
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

                  /// DISEASE
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
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  /// BUTTON 1 — EXPLANATION
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.info),
                      label: const Text("Why This Result?"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => showExplanation(context, disease),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// BUTTON 2 — LEARN MORE
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.search),
                      label: const Text("Learn More"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        String query = buildSearchQuery(disease);
                        openSearch(query);
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// BUTTON 3 — TREATMENTS
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.medical_services),
                      label: const Text("Recommended Treatments"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        openTreatment(disease);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SCAN AGAIN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Scan Another Image"),
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
