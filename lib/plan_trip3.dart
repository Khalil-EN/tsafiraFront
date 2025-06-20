import 'package:flutter/material.dart';
import 'plan_trip4.dart';
import 'package:provider/provider.dart';
import 'providers/plan_provider.dart'; // Import the provider


class TravelersSelection extends StatefulWidget {
  const TravelersSelection({Key? key}) : super(key: key);

  @override
  _TravelersSelectionState createState() => _TravelersSelectionState();
}

class _TravelersSelectionState extends State<TravelersSelection> {
  // Options for who's traveling - using custom images instead of icons
  final List<Map<String, dynamic>> travelOptions = [
    {
      'title': 'Just Me',
      'description': 'A sole traveler in exploration',
      'image': 'assets/alonee.png', // Using custom image
      'people': 1,
    },
    {
      'title': 'A Couple',
      'description': 'Two travelers in tandem',
      'image': 'assets/couplee.png', // Using custom image
      'people': 2,
    },
    {
      'title': 'Family',
      'description': 'A group of fun loving adventurers',
      'image': 'assets/familyy.png', // Using custom image
      'people': 0, // To be specified by user
    },
    {
      'title': 'Friends',
      'description': 'A bunch of thrill-seekers',
      'image': 'assets/friendss.png', // Using custom image
      'people': 0, // To be specified by user
    },
  ];

  // Currently selected option
  String? selectedOption;
  int peopleCount = 1;
  bool showPeopleSelector = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Title
              const Text(
                "Who's Traveling",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Subtitle
              const Text(
                'Choose your travelers',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Travel options
              Expanded(
                child: ListView.builder(
                  itemCount: travelOptions.length,
                  itemBuilder: (context, index) {
                    final option = travelOptions[index];
                    final isSelected = selectedOption == option['title'];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0), // Increased spacing
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOption = option['title'];
                            
                            // Reset and show people selector if needed
                            if (option['title'] == 'Family' || option['title'] == 'Friends') {
                              showPeopleSelector = true;
                              peopleCount = 3; // Default for Family/Friends
                            } else {
                              showPeopleSelector = false;
                              peopleCount = option['people'];
                            }
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22), // Increased padding for larger box
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFFF1EFFF),
                            borderRadius: BorderRadius.circular(12),
                            // Adding subtle shadow for better visualization
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option['title'],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18, // Increased font size
                                      ),
                                    ),
                                    const SizedBox(height: 6), // Increased spacing
                                    Text(
                                      option['description'],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white.withOpacity(0.8) : Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Image with original color (no color filter)
                              Image.asset(
                                option['image'],
                                width: 32, // Increased image size
                                height: 32, // Increased image size
                                // Removed color property to keep original image colors
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // People count selector (shows only for Family or Friends)
              if (showPeopleSelector) ...[
                const Center( // Center alignment
                  child: Text(
                    'How many people?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Centered counter controls
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Use minimum space needed
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (peopleCount > 2) {
                              peopleCount--;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: const Color(0xFF6C63FF),
                        iconSize: 30, // Larger icon
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1EFFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$peopleCount',
                          style: const TextStyle(
                            fontSize: 22, // Larger text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            peopleCount++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: const Color(0xFF6C63FF),
                        iconSize: 30, // Larger icon
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              // Continue button
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56, // Taller button
                  child: ElevatedButton(
                    onPressed: selectedOption == null ? null : () {
                      provider.setGroupType(selectedOption!);
                      provider.setNbrPeople(peopleCount);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TravelDatesScreen()),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF), // Purple color instead of black
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16, // Larger font
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}