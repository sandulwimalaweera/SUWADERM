import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'skin_capture_screen.dart';
import 'about_us_screen.dart';
import 'login_screen.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('Health Tips'),
        backgroundColor: const Color(0xFF7B1FA2),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8EAF6), Color(0xFFF3E5F5)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTipCard(
              'Stay Hydrated',
              'Drink plenty of water throughout the day to keep your skin hydrated and healthy.',
              Icons.local_drink,
            ),
            _buildTipCard(
              'Protect from Sun',
              'Use sunscreen with at least SPF 30, wear protective clothing, and avoid prolonged sun exposure.',
              Icons.wb_sunny,
            ),
            _buildTipCard(
              'Healthy Diet',
              'Eat a balanced diet rich in fruits, vegetables, and omega-3 fatty acids for healthy skin.',
              Icons.restaurant,
            ),
            _buildTipCard(
              'Gentle Cleansing',
              'Use mild, fragrance-free cleansers and avoid hot water that can strip natural oils from your skin.',
              Icons.clean_hands,
            ),
            _buildTipCard(
              'Moisturize Regularly',
              'Apply moisturizer daily to maintain skin barrier and prevent dryness.',
              Icons.spa,
            ),
            _buildTipCard(
              'Avoid Smoking',
              'Smoking accelerates skin aging and can worsen skin conditions.',
              Icons.smoke_free,
            ),
            _buildTipCard(
              'Regular Check-ups',
              'Monitor your skin regularly and consult a dermatologist if you notice any unusual changes.',
              Icons.medical_services,
            ),
            _buildTipCard(
              'Stress Management',
              'Practice stress-reducing activities like exercise, meditation, or hobbies to maintain skin health.',
              Icons.self_improvement,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF7B1FA2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF7B1FA2),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B1FA2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                icon: Icons.home,
                title: "Home",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
              ),
              _drawerItem(
                icon: Icons.camera_alt,
                title: "Scan",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SkinCaptureScreen()),
                  );
                },
              ),
              _drawerItem(
                icon: Icons.lightbulb,
                title: "Health Tips",
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
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
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
}
