import 'dart:ffi';

import 'package:flutter/material.dart';
import 'plan_trip7.dart';
import 'package:provider/provider.dart';
import 'providers/plan_provider.dart';

class RestaurantPreferences extends StatefulWidget {
  const RestaurantPreferences({Key? key}) : super(key: key);

  @override
  _RestaurantPreferencesState createState() => _RestaurantPreferencesState();
}

class _RestaurantPreferencesState extends State<RestaurantPreferences> {
  // Meals selection
  final Map<String, bool> meals = {
    'Breakfast': false,
    'Lunch': false,
    'Dinner': false,
  };

  // Restaurant types
  final Map<String, bool> restaurantTypes = {
    'Fast-Food': false,
    'Traditional Moroccan': false,
    'Modern (European/Asian)': false,
    'Seafood': false,
    'Café': false,
  };

  // Payment and service features
  final Map<String, bool> paymentFeatures = {
    'Cash Payment': false,
    'Credit Card': false,
    'WiFi': false,
    'Takeout': false,
  };

  // Dietary preferences
  final Map<String, bool> dietaryPreferences = {
    'Vegan Options': false,
    'Vegetarian Friendly': false,
    'Gluten-Free Options': false,
    'Diabetic Friendly': false,
    'Halal': false,
  };

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

              const SizedBox(height: 16),

              // Title
              const Text(
                'Restaurant Preferences',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A55A2),
                ),
              ),

              const SizedBox(height: 8),

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
                        'Select which meals you want to eat at restaurants, preferred cuisine types, and special features you need.',
                        style: TextStyle(
                          color: Color(0xFF795548),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),

                    // Meals section
                    const Text(
                      'Which meals will you eat at restaurants?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A55A2),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Meal options in a row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: meals.keys.map((meal) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  meals[meal] = !meals[meal]!;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: meals[meal]!
                                      ? const Color(0xFF6C63FF)
                                      : const Color(0xFFF1EFFF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      _getIconForMeal(meal),
                                      color: meals[meal]!
                                          ? Colors.white
                                          : const Color(0xFF6C63FF),
                                      size: 24,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      meal,
                                      style: TextStyle(
                                        color: meals[meal]!
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

                    // Restaurant Types section
                    const Text(
                      'Preferred Cuisine Types',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A55A2),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Restaurant type options
                    _buildCheckboxList(restaurantTypes, _getIconForRestaurantType),

                    const SizedBox(height: 24),

                    // Features section
                    const Text(
                      'Payment & Service Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A55A2),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Payment and service features grid
                    _buildFeaturesGrid(paymentFeatures, _getIconForPaymentFeature),

                    const SizedBox(height: 24),

                    // Dietary preferences section
                    const Text(
                      'Dietary Preferences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A55A2),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Dietary preferences grid
                    _buildFeaturesGrid(dietaryPreferences, _getIconForDietaryPreference),

                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Navigation button
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SizedBox(
                  width: double.infinity, // Make button full width
                  child: ElevatedButton(
                    onPressed: _anySelectionMade()
                        ? () {
                      List<String> selectedMeals = [];
                      List<String> selectedRestaurantTypes = [];
                      List<String> selectedPaymentFeatures = [];
                      List<String> selectedDietaryPreferences = [];
                      meals.forEach((key, value) {
                        if (value) {
                          selectedMeals.add(key);
                        }
                      });
                      restaurantTypes.forEach((key,value){
                        if(value){
                          selectedRestaurantTypes.add(key);
                        }
                      });
                      paymentFeatures.forEach((key,value){
                        if(value){
                          selectedPaymentFeatures.add(key);
                        }
                      });
                      dietaryPreferences.forEach((key,value){
                        if(value){
                          selectedDietaryPreferences.add(key);
                        }
                      });
                      provider.setSelectedDietary(selectedDietaryPreferences);
                      provider.setSelectedRestaurantTypes(selectedRestaurantTypes);
                      provider.setSelectedPaymentFeatures(selectedPaymentFeatures);
                      provider.setSelectedMeals(selectedMeals);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlanningMethodSelection()),
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

  // Helper methods

  // Build a list of checkboxes from a map
  Widget _buildCheckboxList(Map<String, bool> items, Function(String) iconProvider) {
    return Column(
      children: items.keys.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                items[item] = !items[item]!;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: items[item]! ? const Color(0xFF6C63FF) : const Color(0xFFF1EFFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    iconProvider(item),
                    color: items[item]! ? Colors.white : const Color(0xFF6C63FF),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item,
                    style: TextStyle(
                      color: items[item]! ? Colors.white : const Color(0xFF6C63FF),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Build a grid of feature items
  Widget _buildFeaturesGrid(Map<String, bool> features, Function(String) iconProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features.keys.elementAt(index);
        final isSelected = features[feature]!;

        return GestureDetector(
          onTap: () {
            setState(() {
              features[feature] = !isSelected;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFFF1EFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  iconProvider(feature),
                  color: isSelected ? Colors.white : const Color(0xFF6C63FF),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF6C63FF),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Check if any selection has been made
  bool _anySelectionMade() {
    return meals.values.any((selected) => selected) ||
        restaurantTypes.values.any((selected) => selected) ||
        paymentFeatures.values.any((selected) => selected) ||
        dietaryPreferences.values.any((selected) => selected);
  }

  // Icons for meals
  IconData _getIconForMeal(String meal) {
    switch (meal) {
      case 'Breakfast':
        return Icons.free_breakfast;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  // Icons for restaurant types
  IconData _getIconForRestaurantType(String type) {
    switch (type) {
      case 'Fast Food':
        return Icons.fastfood;
      case 'Traditional Moroccan':
        return Icons.local_dining;
      case 'Modern (European/Asian)':
        return Icons.restaurant;
      case 'Seafood':
        return Icons.set_meal;
      case 'Café':
        return Icons.coffee;
      default:
        return Icons.restaurant;
    }
  }

  // Icons for payment features
  IconData _getIconForPaymentFeature(String feature) {
    switch (feature) {
      case 'Cash Payment':
        return Icons.money;
      case 'Credit Card':
        return Icons.credit_card;
      case 'WiFi Available':
        return Icons.wifi;
      case 'Takeout Option':
        return Icons.takeout_dining;
      default:
        return Icons.check_circle_outline;
    }
  }

  // Icons for dietary preferences
  IconData _getIconForDietaryPreference(String preference) {
    switch (preference) {
      case 'Vegan Options':
        return Icons.eco;
      case 'Vegetarian Friendly':
        return Icons.spa;
      case 'Gluten-Free Options':
        return Icons.no_food;
      case 'Diabetic Friendly':
        return Icons.monitor_heart;
      case 'Halal':
        return Icons.restaurant_menu;
      default:
        return Icons.food_bank;
    }
  }
}