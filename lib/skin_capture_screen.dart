import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'skin_disease_classifier.dart';
import 'questionnaire_screen.dart';
import 'result_screen.dart';
import 'about_us_screen.dart';

class SkinCaptureScreen extends StatefulWidget {
  const SkinCaptureScreen({super.key});

  @override
  State<SkinCaptureScreen> createState() => _SkinCaptureScreenState();
}

class _SkinCaptureScreenState extends State<SkinCaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  final SkinDiseaseClassifier _classifier = SkinDiseaseClassifier();

  File? _image;
  bool _loading = false;

  /// Thresholds
  final double confidenceThreshold = 0.55;
  final double predictionGapThreshold = 0.10;

  @override
  void initState() {
    super.initState();
    _classifier.loadModel();
  }

  Future<void> _pick(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (file != null) {
      setState(() => _image = File(file.path));
    }
  }

  /// ===============================
  /// SCAN IMAGE
  /// ===============================

  Future<void> _scan() async {
    if (_image == null || _loading) return;

    setState(() => _loading = true);

    final result = await _classifier.classifyImage(_image!);

    if (!mounted) return;

    setState(() => _loading = false);

    double confidence = result['topConfidence'];

    List predictions = result['allPredictions'];

    double secondConfidence =
        predictions.length > 1 ? predictions[1]['confidence'] : 0.0;

    double gap = confidence - secondConfidence;

    /// CASE 1 — Very low confidence
    if (confidence < confidenceThreshold) {
      final notSkinResult = {
        'topLabel': 'Not a skin image',
        'topConfidence': confidence,
        'allPredictions': [],
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            image: _image!,
            result: notSkinResult,
          ),
        ),
      );

      return;
    }

    /// CASE 2 — Model confused (likely healthy skin)
    if (gap < predictionGapThreshold) {
      final healthyResult = {
        'topLabel': 'Healthy or unclear skin condition',
        'topConfidence': confidence,
        'allPredictions': predictions,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            image: _image!,
            result: healthyResult,
          ),
        ),
      );

      return;
    }

    /// CASE 3 — Real disease prediction
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionnaireScreen(
          image: _image!,
          result: result,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _classifier.dispose();
    super.dispose();
  }

  /// ===============================
  /// UI
  /// ===============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          /// TOP CURVE
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(90),
              ),
            ),
          ),

          /// BOTTOM CURVE
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 180,
              width: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(120),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
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
                            "Skin Image Capture",
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
                ),

                const SizedBox(height: 40),

                /// IMAGE PREVIEW
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1C4E9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue, width: 3),
                    ),
                    child: _image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.search,
                                  size: 60, color: Colors.black54),
                              SizedBox(height: 10),
                              Text("No Preview"),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 50),

                /// BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _circleButton(
                      icon: Icons.photo,
                      label: "Select From Gallery",
                      onTap: () => _pick(ImageSource.gallery),
                    ),
                    _circleButton(
                      icon: Icons.camera_alt,
                      label: "Take a Photo",
                      onTap: () => _pick(ImageSource.camera),
                    ),
                  ],
                ),

                const Spacer(),

                /// SCAN BUTTON
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, right: 30),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: (_image == null || _loading) ? null : _scan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAB47BC),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Scan"),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF7B1FA2)),
              ),
              const SizedBox(height: 10),
              const Text(
                "Hi, User 👋",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              _drawerItem(
                icon: Icons.camera_alt,
                title: "Scan",
                onTap: () => Navigator.pop(context),
              ),
              _drawerItem(
                icon: Icons.info_outline,
                title: "About Us",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                  );
                },
              ),
              const Spacer(),
              const Divider(color: Colors.white70),
              _drawerItem(
                icon: Icons.logout,
                title: "Logout",
                onTap: () => Navigator.pop(context),
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
      title: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _circleButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFE1BEE7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 100,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        )
      ],
    );
  }
}
