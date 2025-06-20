import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/plan_provider.dart'; // Import the provider
import 'services/api.dart';
import 'premiumUpgradePage.dart';
import "exceptions/premium_required_exception.dart";
import "exceptions/session_expired_exception.dart";
import "login.dart";

class SuggestMyPlan extends StatefulWidget {
  const SuggestMyPlan({Key? key}) : super(key: key);

  @override
  State<SuggestMyPlan> createState() => _SuggestMyPlanState();
}

class _SuggestMyPlanState extends State<SuggestMyPlan> {
  int _selectedDayIndex = 0;
  List<DateTime> days = [];

  List<DateTime> generateDaysList(int numberOfDays) {
    List<DateTime> days = [];
    for (int i = 0; i < numberOfDays; i++) {
      days.add(DateTime.now().add(Duration(days: i)));
    }
    return days;
  }



  late Future<Map<String, dynamic>> _planData;

  @override
  void initState() {
    super.initState();
    final planProvider = Provider.of<PlanProvider>(context, listen: false);
    final data = planProvider.toMap();
    _planData = Api.submitPlanData(data); // Fetch the plan data asynchronously
    print("Sending Data: $_planData");
  }

  // This method will add a new day with initial attractions
  void _addNewDay() {
    setState(() {
      final newDayIndex = days.length;
      days.add(days.last.add(const Duration(days: 1)));

      _planData = _planData.then((planData) {
        final updatedPlanData = Map<String, dynamic>.from(
            planData); // Clone the map
        updatedPlanData[newDayIndex.toString()] = [
          {
            'name': 'Royal Palace',
            'location': 'Downtown Rabat',
            'image': 'https://example.com/palace.jpg',
            'type': 'activity'
          },
          {
            'name': 'Rabat Zoo',
            'location': 'Temara, Rabat',
            'image': 'https://example.com/zoo.jpg',
            'type': 'activity'
          },
          {
            'name': 'Café La Place',
            'location': 'Hassan, Rabat',
            'image': 'https://example.com/cafeplace.jpg',
            'type': 'restaurant'
          },
          {
            'name': 'Dar El Medina',
            'location': 'Medina of Rabat',
            'image': 'https://example.com/darelmedina.jpg',
            'type': 'restaurant'
          },
        ];
        return updatedPlanData; // Return the updated plan data
      });
    });
  }

  // This method will add a new attraction to the selected day
  void _addNewAttraction() {
    setState(() {
      _planData = _planData.then((planData) {
        final currentAttractions = List<Map<String, dynamic>>.from(
            planData[_selectedDayIndex.toString()] ??
                []); // Clone current attractions
        currentAttractions.add({
          'name': 'New Attraction',
          'location': 'Rabat City',
          'image': 'https://example.com/new.jpg',
          'type': 'activity'
        });

        final updatedPlanData = Map<String, dynamic>.from(
            planData); // Clone map
        updatedPlanData[_selectedDayIndex.toString()] =
            currentAttractions; // Update day attractions
        return updatedPlanData; // Return the updated plan data
      });
    });
  }

  // Function to get the month name from its number
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
  String _getTitleName(int index, int totalDays) {
    if (index == 0) return 'Residency';
    if (index == totalDays ) return 'Night activities';
    if (index <= totalDays) return 'Day $index';
    return '';
  }



  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context, listen: false);
    List<DateTime> days = generateDaysList(planProvider.days+1);

    return FutureBuilder(
      future: _planData,
      // The future you are waiting for (you can use _planData directly)
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Suggested Plan for User'),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          if (snapshot.error is PremiumRequiredException) {
            return PremiumUpgradePage();
          }
          if (snapshot.error is SessionExpiredException) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login(showSessionExpired: true,)),
              );
            });
          }
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Suggested Plan for User'),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData || snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Suggested Plan for User'),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Center(child: Text('No plan data available.')),
          );
        }

        if (snapshot.hasData) {
          final planData = snapshot.data!;
          final selectedDayAttractions = planData['plan']?[_selectedDayIndex
              .toString()] ?? [];
          print(selectedDayAttractions);

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Suggested Plan for User'),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Column(
              children: [
                // Day selector (your existing UI code for day selection)
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 53, 177, 255), width: 2),
                    ),
                  ),
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: days.length + 3,
                    itemBuilder: (context, index) {
                      if (index == days.length + 2) {
                        return Center(
                          child: IconButton(
                            icon: const Icon(Icons.add_circle_outline,
                                color: Color.fromARGB(255, 24, 189, 255)),
                            onPressed: _addNewDay,
                          ),
                        );
                      }

                      final isSelected = index == _selectedDayIndex;
                      final isDay = index > 0 && index <= days.length;
                      final day = isDay ? days[index - 1] : null;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDayIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: isSelected
                                ? const Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 9, 210, 255), width: 4),
                            )
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getTitleName(index, days.length),
                                style: TextStyle(
                                  fontWeight:
                                  isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              if (isDay)
                                Text(
                                  '${day!.day} ${_getMonthName(day.month)} ${day.year}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Plans for the selected day
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedDayAttractions.length,
                    itemBuilder: (context, index) {
                      final attraction = selectedDayAttractions[index];
                      print(attraction);
                      print(index);


                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Timeline marker
                              SizedBox(
                                width: 60,
                                child: Center(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(top: 16),
                                    decoration: BoxDecoration(
                                      color: index == 0 ? Colors.blue : Colors
                                          .grey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + index),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Attraction Card
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
                                      margin: const EdgeInsets.only(
                                          right: 16, top: 16, bottom: 0),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          // Image container
                                          Container(
                                            height: 120,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius
                                                  .vertical(
                                                top: Radius.circular(8),
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    attraction['imageurl']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          // Information
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      attraction['name'],
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      (attraction['tags'] is List)
                                                          ? attraction['tags'].join(', ')
                                                          : attraction['tags'] ?? '', // fallback to empty string if null
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons
                                                          .bookmark_border),
                                                      onPressed: () {},
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.more_horiz),
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Transport method button (for all except last attraction)
                                    if (index <
                                        selectedDayAttractions.length - 1)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: 16, top: 8, bottom: 8),
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              8),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Tap Here To Choose Your Transport Method',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _addNewAttraction,
              backgroundColor: const Color.fromARGB(255, 9, 214, 255),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Suggested Plan for User'),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Center(child: Text('No data available')),
        );
      },
    );
  }
}
