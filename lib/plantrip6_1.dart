import 'package:flutter/material.dart';
import 'plantrip6_2.dart';
import 'package:provider/provider.dart';
import 'providers/plan_provider.dart'; // Import the provider

class HotelPreferences extends StatefulWidget {
  const HotelPreferences({Key? key}) : super(key: key);

  @override
  _HotelPreferencesState createState() => _HotelPreferencesState();
}

class _HotelPreferencesState extends State<HotelPreferences> {
  // Selected accommodation type
  String? selectedAccommodationType;

  // Accommodation types
  final List<String> accommodationTypes = [
    'Hotel',
    'Logement',
  ];

  // Location preferences
  final List<String> locationOptions = [
    'City Center',
    'Near the Beach',
    'Calm/Quiet Area',
    'Rural Area',
  ];

  // Set to keep track of selected locations
  final Set<String> selectedLocations = {};

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FB),
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
                'Accommodation Preferences',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A55A2),
                ),
              ),

              const SizedBox(height: 10),

              // Informational note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFFE082), width: 1),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFFFFA000), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'First, select your accommodation type, then choose your preferred locations.',
                        style: TextStyle(
                          color: Color(0xFF795548),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Accommodation type selection
              const Text(
                'Select Accommodation Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A55A2),
                ),
              ),

              const SizedBox(height: 10),

              // Accommodation type options
              Row(
                children: accommodationTypes.map((type) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAccommodationType = type;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selectedAccommodationType == type
                                ? const Color(0xFF6C63FF)
                                : const Color(0xFFF1EFFF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedAccommodationType == type
                                  ? const Color(0xFF6C63FF)
                                  : const Color(0xFFD1CFFF),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                type == 'Hotel' ? Icons.hotel : Icons.home,
                                color: selectedAccommodationType == type
                                    ? Colors.white
                                    : const Color(0xFF6C63FF),
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                type,
                                style: TextStyle(
                                  color: selectedAccommodationType == type
                                      ? Colors.white
                                      : const Color(0xFF6C63FF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Location preferences title
              const Text(
                'Select Location Preferences',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A55A2),
                ),
              ),

              const SizedBox(height: 10),

              // Location preferences list
              Expanded(
                child: ListView.builder(
                  itemCount: locationOptions.length,
                  itemBuilder: (context, index) {
                    final location = locationOptions[index];
                    final isSelected = selectedLocations.contains(location);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedLocations.remove(location);
                            } else {
                              selectedLocations.add(location);
                            }
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFFF1EFFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              // Location icon based on type
                              Icon(
                                _getIconForLocation(location),
                                color: isSelected ? Colors.white : const Color(0xFF6C63FF),
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              // Location name
                              Text(
                                location,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF6C63FF),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Navigation button
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SizedBox(
                  width: double.infinity, // Make button full width
                  child: ElevatedButton(
                    onPressed: selectedAccommodationType != null && selectedLocations.isNotEmpty
                        ? () {
                      provider.setAccomodationType!(selectedAccommodationType!);
                      provider.setSelectedHotelLocations!(selectedLocations!);
                      // Navigate to next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantPreferences()),
                      );
                    }
                        : null, // Disable if nothing selected
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      disabledBackgroundColor: const Color(0xFFD1CFFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "NEXT",
                      style: TextStyle(
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

  // Helper method to get appropriate icons for locations
  IconData _getIconForLocation(String location) {
    switch (location) {
      case 'City Center':
        return Icons.location_city;
      case 'Near the Beach':
        return Icons.beach_access;
      case 'Calm/Quiet Area':
        return Icons.nights_stay;
      case 'Rural Area':
        return Icons.nature_people;
      default:
        return Icons.place;
    }
  }
}