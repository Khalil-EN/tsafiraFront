import 'package:flutter/material.dart';
import 'plan_trip3.dart'; // Import for navigation
import 'package:provider/provider.dart';
import 'providers/plan_provider.dart'; // Import the provider

class PlanTrip2 extends StatefulWidget {
  const PlanTrip2({Key? key}) : super(key: key);

  @override
  _PlanTrip2State createState() => _PlanTrip2State();
}

class _PlanTrip2State extends State<PlanTrip2> {
  // List of Moroccan cities
  final List<String> cities = [
    'Tanger', 
    'Rabat', 
    'Marrakech', 
    'Agadir', 
    'Essaouira', 
    'Chefchaouen'
  ];
  
  // Set to keep track of selected cities
  final Set<String> selectedCities = {};

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
              
              // Updated Title
              const Text(
                'Select your preferred destination(s)',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A55A2),
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Note about city availability
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
                        'Currently, trip planning is only available for Rabat. More cities will be added in future updates.',
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
              
              // Cities list - each city in a separate line
              Expanded(
                child: ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    final isSelected = selectedCities.contains(city);
                    final isRabat = city == 'Rabat';
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedCities.remove(city);
                            } else {
                              selectedCities.add(city);
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
                              Text(
                                city,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF6C63FF),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              if (isRabat) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white.withOpacity(0.3) : const Color(0xFF6C63FF).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Available',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected ? Colors.white : const Color(0xFF6C63FF),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Navigation button (Skip button removed)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SizedBox(
                  width: double.infinity, // Make button full width
                  child: ElevatedButton(
                    onPressed: () {
                      provider.setSelectedCities(selectedCities);
                      // Navigate to PlanTrip3 screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TravelersSelection(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
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
}