import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // App Icon/Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🎵',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // App Name
            const Text(
              'Theme Box Controller',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Version
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 30),

            // Description Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About This App',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Control your Theme Box IoT device with ease. Change room atmosphere using themes with LEDs, sounds, and ambient effects. Perfect for creating the right mood for any occasion.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Developer Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Developer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Color(0xFF667EEA)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ahmed',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'ICT Engineering Student',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Features Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      icon: Icons.palette,
                      title: 'Multiple Themes',
                      description: 'Forest, Christmas, and Campfire modes',
                    ),
                    _buildFeatureItem(
                      icon: Icons.tune,
                      title: 'Customizable Settings',
                      description: 'Adjust brightness, volume, and speed',
                    ),
                    _buildFeatureItem(
                      icon: Icons.wifi,
                      title: 'WiFi Control',
                      description: 'Connect via local network',
                    ),
                    _buildFeatureItem(
                      icon: Icons.phone_android,
                      title: 'Mobile Friendly',
                      description: 'Intuitive touch interface',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Licenses Button
            OutlinedButton.icon(
              onPressed: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Theme Box Controller',
                  applicationVersion: '1.0.0',
                  applicationIcon: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text('🎵', style: TextStyle(fontSize: 30)),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.description),
              label: const Text('Open Source Licenses'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Copyright
            Text(
              '© 2025 Ahmed. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              'Made with ❤️ for IoT enthusiasts',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF667EEA), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
