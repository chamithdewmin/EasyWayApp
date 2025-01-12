import 'package:firebase/screens/home/home.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _locationAccessEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900]!,
              Colors.orange[800]!,
              Colors.orange[400]!,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "     Settings",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "          Manage your preferences",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: ListView(
                  children: [
                    _buildSwitchTile(
                      title: 'Notifications',
                      subtitle: 'Enable or disable notifications',
                      value: _notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: 'Dark Mode',
                      subtitle: 'Switch between light and dark themes',
                      value: _darkModeEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _darkModeEnabled = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: 'Location Access',
                      subtitle: 'Allow access to your location',
                      value: _locationAccessEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _locationAccessEnabled = value;
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip, color: Colors.orange),
                      title: const Text('Privacy Policy'),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Privacy Policy clicked')),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info, color: Colors.orange),
                      title: const Text('About Us'),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('About Us clicked')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 18)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      value: value,
      activeColor: Colors.orange,
      onChanged: onChanged,
    );
  }
}
