import 'package:flutter/material.dart';
import 'skin_capture_screen.dart';
import 'about_us_screen.dart';
import 'tips_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('SUWADERM'),
        backgroundColor: const Color(0xFF7B1FA2),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7B1FA2), Color(0xFF512DA8)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.health_and_safety,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to SUWADERM',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your Skin Health Companion',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                _buildMenuButton(
                  context,
                  'Scan Skin',
                  Icons.camera_alt,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SkinCaptureScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  'Health Tips',
                  Icons.lightbulb,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TipsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  'About Us',
                  Icons.info,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon,
      VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF7B1FA2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
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
                onTap: () => Navigator.pop(context),
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
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TipsScreen()),
                  );
                },
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
