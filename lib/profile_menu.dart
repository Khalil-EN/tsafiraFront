// profile_menu.dart
import 'package:flutter/material.dart';
import "login.dart";
import 'services/api.dart';

class ProfileMenu extends StatelessWidget {
  final VoidCallback onClose;
  
  const ProfileMenu({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent overlay to dim the background
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        
        // Actual menu container - positioned from the left
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          child: Container(
            width: 280,
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: onClose,
                        child: Icon(Icons.close, color: Colors.grey),
                      ),
                    ),
                  ),
                  
                  // User profile section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        // Profile image
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage('assets/profile_image.jpg'),
                          // Fallback if image doesn't load
                          onBackgroundImageError: (exception, stackTrace) {},
                          child: Image.asset(
                            'assets/profile_image.jpg', 
                            errorBuilder: (context, error, stackTrace) => 
                                Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        // Name and email
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Melissa Peters',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'melpeters@gmail.com',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                  
                  // Menu items
                  SizedBox(height: 16),
                  _buildMenuItem(Icons.list_alt, 'List of Trip places', Colors.grey.shade600),
                  _buildMenuItem(Icons.support_agent, 'Customer Support', Colors.grey.shade600),
                  _buildMenuItem(Icons.privacy_tip, 'Privacy and Policy', Colors.grey.shade600),
                  _buildMenuItem(Icons.description, 'Terms and Conditions', Colors.grey.shade600),
                  _buildMenuItem(Icons.settings, 'Setting', Colors.grey.shade600),
                  
                  // Spacer to push logout button to bottom
                  Spacer(),
                  
                  // Logout button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 8),
                          ElevatedButton(onPressed:  () async{
                            await Api.logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()));}, child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // Individual menu item
  Widget _buildMenuItem(IconData icon, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 22,
          ),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}