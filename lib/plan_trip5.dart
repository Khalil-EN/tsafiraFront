import 'package:flutter/material.dart';
import 'plan_trip6.dart';
import 'package:provider/provider.dart';
import 'providers/plan_provider.dart'; // Import the provider

class BudgetSelectionScreen extends StatefulWidget {
  const BudgetSelectionScreen({Key? key}) : super(key: key);

  @override
  _BudgetSelectionScreenState createState() => _BudgetSelectionScreenState();
}

class _BudgetSelectionScreenState extends State<BudgetSelectionScreen> {
  // Budget options with images
  final List<Map<String, dynamic>> budgetOptions = [
    {
      'title': 'Cheap',
      'description': 'Stay conscious of costs',
      'image': 'assets/cheap.png',
    },
    {
      'title': 'Moderate',
      'description': 'Keep cost on the average side',
      'image': 'assets/moderate.png',
    },
    {
      'title': 'Luxury',
      'description': 'Don\'t worry about cost',
      'image': 'assets/luxury.png',
    },
  ];

  String? selectedOption;
  TextEditingController budgetController = TextEditingController();
  bool showNotification = false;
  String notificationMessage = '';
  String suggestedOption = '';

  // Budget thresholds in DH
  static const double CHEAP_THRESHOLD = 2500;
  static const double MODERATE_THRESHOLD = 9000;

  @override
  void initState() {
    super.initState();
    budgetController.addListener(_checkBudgetCategory);
  }

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  // Determine suggested budget category based on amount
  String? _getSuggestedCategory(double amount) {
    if (amount < CHEAP_THRESHOLD) return 'Cheap';
    if (amount < MODERATE_THRESHOLD) return 'Moderate';
    return 'Luxury';
  }

  // Check for mismatches between selected option and entered budget
  void _checkBudgetCategory() {
    if (selectedOption == null || budgetController.text.isEmpty) {
      setState(() {
        showNotification = false;
      });
      return;
    }

    double? budgetNum = double.tryParse(budgetController.text);
    if (budgetNum == null) return;

    String? suggestedCategory = _getSuggestedCategory(budgetNum);
    if (suggestedCategory != null && suggestedCategory != selectedOption) {
      setState(() {
        suggestedOption = suggestedCategory;
        notificationMessage =
            'Your budget of $budgetNum DH suggests "$suggestedCategory" rather than "$selectedOption". Do you want to change?';
        showNotification = true;
      });
    } else {
      setState(() {
        showNotification = false;
      });
    }
  }

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
                "Budget",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Subtitle
              const Text(
                'Choose spending habits for your trip',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Budget options - now much bigger
              Expanded(
                child: ListView.builder(
                  itemCount: budgetOptions.length,
                  itemBuilder: (context, index) {
                    final option = budgetOptions[index];
                    final isSelected = selectedOption == option['title'];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0), // Increased bottom padding
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOption = option['title'];
                            _checkBudgetCategory(); // Re-check if notification should show
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          // Significantly increased height for bigger boxes
                          height: 100, 
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFFF1EFFF),
                            borderRadius: BorderRadius.circular(16), // Slightly larger radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08), // Slightly stronger shadow
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option['title'],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.w600, // Slightly bolder
                                        fontSize: 22, // Larger font size
                                      ),
                                    ),
                                    const SizedBox(height: 8), // More space between title and description
                                    Text(
                                      option['description'],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white.withOpacity(0.8) : Colors.black54,
                                        fontSize: 16, // Larger description text
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Larger icon
                              Image.asset(
                                option['image'],
                                width: 48, // Much larger icon
                                height: 48, // Much larger icon
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Budget input field (only appears after selection)
              if (selectedOption != null) ...[
                const Text(
                  'Enter your budget amount',
                  style: TextStyle(
                    fontSize: 18, // Larger text
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 70, // Taller input field
                  child: TextField(
                    controller: budgetController,
                    style: const TextStyle(
                      fontSize: 18, // Larger text in the input
                    ),
                    decoration: InputDecoration(
                      labelText: 'Your budget (DH)',
                      labelStyle: const TextStyle(
                        fontSize: 16, // Larger label
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(width: 2), // Thicker border
                      ),
                      hintText: 'Type your budget amount here',
                      filled: true,
                      fillColor: const Color(0xFFF1EFFF),
                      suffixText: 'DH',
                      suffixStyle: const TextStyle(
                        fontSize: 18, // Larger suffix
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22), // More padding inside
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 20), // More spacing
              ],
              
              // Notification for budget mismatch
              if (showNotification)
                Container(
                  padding: const EdgeInsets.all(20), // More padding
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(16), // Larger radius
                    border: Border.all(color: Colors.amber.shade300, width: 2), // Thicker border
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationMessage,
                        style: const TextStyle(fontSize: 16), // Larger text
                      ),
                      const SizedBox(height: 16), // More spacing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showNotification = false;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF6C63FF),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Larger button
                              textStyle: const TextStyle(fontSize: 16), // Larger text
                            ),
                            child: const Text('Keep current'),
                          ),
                          const SizedBox(width: 12), // More spacing
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedOption = suggestedOption;
                                showNotification = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Larger button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Larger radius
                              ),
                              textStyle: const TextStyle(fontSize: 16), // Larger text
                            ),
                            child: const Text('Change to suggested'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              
              // Continue button - bigger
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 64, // Taller button
                  child: ElevatedButton(
                    onPressed: (selectedOption != null && budgetController.text.isNotEmpty) 
                        ? () {
                      int? budget = int.tryParse(budgetController.text);
                      provider.setBudget(budget!);
                      provider.setBudgetCategory(selectedOption!);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ActivityPreferences()),
                        );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // Larger radius
                      ),
                      disabledBackgroundColor: Colors.grey,
                      elevation: 3, // Slightly more elevation
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 18, // Larger text
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