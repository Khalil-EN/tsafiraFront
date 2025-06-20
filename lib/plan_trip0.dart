import 'package:flutter/material.dart';
import 'HomePage.dart';  // This should import your actual FlightIntroScreen file
import 'plan_trip1.dart';  // Import the plan_trip1.dart file

class FlightIntroScreen extends StatelessWidget {
  const FlightIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FB), // White background as shown in image
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration with plane and path - positioned in the middle
                    SizedBox(
                      height: 250,
                      width: double.infinity, // Full width
                      child: Center( // Ensure the stack is centered
                        child: Stack(
                          alignment: Alignment.center, // Center alignment
                          children: [
                            // Ellipse path
                            Image.asset(
                              'assets/plane_trip1.png',
                              width: 320, // Adjusted size to match image
                            ),
                            // Plane icon
                            Image.asset(
                              'assets/plane_trip2.png',
                              width: 320, // Adjusted size to match image
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Main heading matching the image
                    const Text(
                      "It look like you did not\nplan your trip yet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600, 
                        color: Color(0xFF5C6BC0), // Blue/purple color as in image
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Subheading
                    const Text(
                      "You Can Create Your Own Trip Plan Now",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFF8C9BAB),
                      ),
                    ),
                    
                    const SizedBox(height: 30), // Increased spacing
                    
                    // DONE button instead of START NOW
                    SizedBox(
                      width: 130, // Narrower button to match image
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to plan_trip1.dart
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PlanTrip1()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF), // Purple button color
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "START NOW",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
}