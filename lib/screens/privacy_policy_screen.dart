import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Introduction',
              'Layover Friends ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and share information about you when you use our app.',
            ),
            _buildSection(
              'Information We Collect',
              '• Name and email address (via Google login)\n• Profile photo\n• Job title and professional information\n• Airport and layover information\n• Messages sent within the app\n• Offers posted on the board',
            ),
            _buildSection(
              'How We Use Your Information',
              '• To create and manage your account\n• To connect you with other travelers at the same airport\n• To enable real-time chat features\n• To display your profile to other users\n• To provide AI-powered travel assistance\n• To improve our services',
            ),
            _buildSection(
              'Information Sharing',
              'Your profile information (name, photo, job title, airport, layover duration) is visible to other users of the app. We do not sell your personal information to third parties.',
            ),
            _buildSection(
              'Data Storage',
              'Your data is stored securely using Google Firebase. We implement industry-standard security measures to protect your information.',
            ),
            _buildSection(
              'Third-Party Services',
              'We use the following third-party services:\n• Google Firebase (authentication and database)\n• AviationStack (flight data)\n• Groq AI (travel assistance)\n• Google Maps (airport information)',
            ),
            _buildSection(
              'Your Rights',
              'You have the right to:\n• Access your personal data\n• Delete your account and data\n• Update your profile information\n• Opt out of communications',
            ),
            _buildSection(
              'Children\'s Privacy',
              'Layover Friends is not intended for users under 18 years of age. We do not knowingly collect information from children.',
            ),
            _buildSection(
              'Contact Us',
              'If you have questions about this Privacy Policy, please contact us at:\nmusthaq258@gmail.com',
            ),
            const SizedBox(height: 32),
            const Text(
              '© 2025 Layover Friends. All rights reserved.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00BFA5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
