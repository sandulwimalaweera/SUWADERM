import 'package:flutter/material.dart';
import 'skin_capture_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          /// FULL GRADIENT BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF9C27B0),
                  Color(0xFF7B1FA2),
                  Color(0xFF6A1B9A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// BOTTOM CURVE
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF7B1FA2),
                    Color(0xFF9C27B0),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(160),
                  topRight: Radius.circular(160),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// HEADER
                  Row(
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "About SuwaDerm",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "SuwaDerm",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Skin Disease Support & Identification System",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _sectionTitle("Project Overview"),
                  const SizedBox(height: 10),
                  _sectionText(
                      "SuwaDerm is a mobile application designed to assist users in identifying common skin conditions. The system allows users to upload or capture a skin image and receive a predicted condition based on image analysis."),

                  const SizedBox(height: 30),

                  _sectionTitle("Key Features"),
                  const SizedBox(height: 10),
                  _sectionText("• Image-based skin condition detection."),
                  const SizedBox(height: 6),
                  _sectionText("• Symptom-based questionnaire validation."),
                  const SizedBox(height: 6),
                  _sectionText("• Confidence score display."),
                  const SizedBox(height: 6),
                  _sectionText(
                      "• Severity level indication (Mild / Moderate / Severe)."),
                  const SizedBox(height: 6),
                  _sectionText("• Nearby clinic and hospital recommendations."),

                  const SizedBox(height: 30),

                  _sectionTitle("How SuwaDerm Works"),
                  const SizedBox(height: 10),
                  _sectionText("1. Capture or upload a skin image."),
                  const SizedBox(height: 6),
                  _sectionText(
                      "2. The system analyzes the image and predicts a possible condition."),
                  const SizedBox(height: 6),
                  _sectionText(
                      "3. A structured questionnaire asks related symptom questions."),
                  const SizedBox(height: 6),
                  _sectionText(
                      "4. The system adjusts confidence based on responses."),
                  const SizedBox(height: 6),
                  _sectionText(
                      "5. A final result is displayed with severity guidance."),

                  const SizedBox(height: 30),

                  _sectionTitle("Purpose of the Application"),
                  const SizedBox(height: 10),
                  _sectionText(
                      "SuwaDerm aims to provide preliminary guidance and awareness regarding common skin diseases. It is especially useful for individuals who may not have immediate access to dermatological consultation."),

                  const SizedBox(height: 30),

                  _sectionTitle("Privacy & Data Protection"),
                  const SizedBox(height: 10),
                  _sectionText(
                      "All image processing is performed locally on the device. SuwaDerm does not store or share personal medical images. User privacy and data security are prioritized."),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SkinCaptureScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAB47BC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Start Using SuwaDerm",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Disclaimer: SuwaDerm is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of a qualified healthcare provider.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= DRAWER =================

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9C27B0),
              Color(0xFF7B1FA2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFF7B1FA2),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Welcome 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              _drawerItem(
                icon: Icons.camera_alt,
                title: "Scan",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SkinCaptureScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              _drawerItem(
                icon: Icons.info_outline,
                title: "About Us",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Spacer(),
              const Divider(color: Colors.white70),
              _drawerItem(
                icon: Icons.logout,
                title: "Logout",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  static Widget _sectionTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  static Widget _sectionText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white70,
        height: 1.5,
      ),
    );
  }
}
