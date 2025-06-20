import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'transport_page.dart';

class PersonalPlanning extends StatefulWidget {
  final String tripName;
  
  const PersonalPlanning({
    Key? key, 
    this.tripName = "Beach Trip"
  }) : super(key: key);

  @override
  _PersonalPlanningState createState() => _PersonalPlanningState();
}

class _PersonalPlanningState extends State<PersonalPlanning> {
  List<Map<String, dynamic>> tripDays = [
    {"day": 1, "date": DateTime.now(), "attractions": [], "transports": []},
  ];

  int selectedDayIndex = 0;

  void addNewDay() {
    setState(() {
      tripDays.add({
        "day": tripDays.length + 1,
        "date": tripDays.last["date"].add(const Duration(days: 1)),
        "attractions": [],
        "transports": [],
      });
    });
  }

  // Modified to NOT add a default transport
  void addAttraction(int dayIndex, String attractionName) {
    setState(() {
      tripDays[dayIndex]["attractions"].add(attractionName);
      // Add empty string for transport if needed
      if (tripDays[dayIndex]["attractions"].length > 1 &&
          tripDays[dayIndex]["transports"].length <
              tripDays[dayIndex]["attractions"].length - 1) {
        tripDays[dayIndex]["transports"].add(""); // Empty string instead of "Taxi"
      }
    });
  }
  
  void addCustomAttraction(int dayIndex, String attractionName) {
    if (attractionName.isNotEmpty) {
      addAttraction(dayIndex, attractionName);
    }
  }

  void updateTransport(int dayIndex, int transportIndex, String newTransport) {
    setState(() {
      tripDays[dayIndex]["transports"][transportIndex] = newTransport;
    });
  }

  void showAttractionChoices(int dayIndex) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Attraction Type"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle, color: Colors.green),
              title: const Text("Add New Attraction"),
              onTap: () {
                Navigator.pop(context);
                showCustomAttractionDialog(dayIndex);
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant, color: Colors.blue),
              title: const Text("Restaurant"),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantListScreen(
                      onSelect: (String selected) => addAttraction(dayIndex, selected),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.hotel, color: Colors.blue),
              title: const Text("Hotel"),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelListScreen(
                      onSelect: (String selected) => addAttraction(dayIndex, selected),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_activity, color: Colors.blue),
              title: const Text("Activity"),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityListScreen(
                      onSelect: (String selected) => addAttraction(dayIndex, selected),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showCustomAttractionDialog(int dayIndex) {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Attraction"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter attraction name",
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              addCustomAttraction(dayIndex, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // Function to build an attraction timeline item
  Widget buildAttractionTimelineItem(int index, String attraction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot and line
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.place,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
            if (index < tripDays[selectedDayIndex]["attractions"].length - 1)
              Container(
                width: 2,
                height: 80, // Height for transport + space
                color: Colors.grey.shade300,
              ),
          ],
        ),
        
        const SizedBox(width: 15),
        
        // Attraction card
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              attraction,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Trip Details Plan',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.tripName,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Day selection row
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tripDays.length + 1, // +1 for add button
              itemBuilder: (context, index) {
                if (index < tripDays.length) {
                  // Day buttons
                  final day = tripDays[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: selectedDayIndex == index ? Colors.blue.withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selectedDayIndex == index ? Colors.blue : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Day ${day["day"]}',
                          style: TextStyle(
                            color: selectedDayIndex == index ? Colors.blue : Colors.black,
                            fontWeight: selectedDayIndex == index ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Add day button
                  return GestureDetector(
                    onTap: addNewDay,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          
          // Date display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Show date of the selected day
                Text(
                  "${tripDays[selectedDayIndex]["date"].day}/${tripDays[selectedDayIndex]["date"].month}/${tripDays[selectedDayIndex]["date"].year}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                // Add attraction button
                ElevatedButton.icon(
                  onPressed: () => showAttractionChoices(selectedDayIndex),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Add Attraction"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          
          // Timeline
          Expanded(
            child: tripDays[selectedDayIndex]["attractions"].isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No attractions added yet',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => showAttractionChoices(selectedDayIndex),
                          icon: const Icon(Icons.add),
                          label: const Text("Add First Attraction"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tripDays[selectedDayIndex]["attractions"].length * 2 - 1,
                    itemBuilder: (context, index) {
                      // For even indices, show attraction
                      if (index % 2 == 0) {
                        final attractionIndex = index ~/ 2;
                        return buildAttractionTimelineItem(
                          attractionIndex,
                          tripDays[selectedDayIndex]["attractions"][attractionIndex],
                        );
                      } 
                      // For odd indices, show transport between attractions
                      else {
                        final transportIndex = index ~/ 2;
                        if (transportIndex < tripDays[selectedDayIndex]["transports"].length) {
                          final transport = tripDays[selectedDayIndex]["transports"][transportIndex];
                          return buildTransportTimelineItem(
                            context, 
                            transportIndex, 
                            transport, 
                            selectedDayIndex,
                            updateTransport
                          );
                        } else {
                          return buildEmptyTransportTimelineItem(
                            context, 
                            transportIndex, 
                            selectedDayIndex,
                            updateTransport
                          );
                        }
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Widget to build transport timeline item when transport is selected
Widget buildTransportTimelineItem(BuildContext context, int transportIndex, String transport, int dayIndex, Function(int, int, String) updateTransport) {
  // Show selected transport or empty state
  IconData transportIcon;
  String transportText = transport;
  
  if (transport.isEmpty) {
    transportIcon = Icons.directions;
    transportText = "Select Transport";
  } else {
    // Determine the right icon based on transport type
    switch (transport) {
      case "Car":
        transportIcon = Icons.directions_car;
        break;
      case "Bus":
        transportIcon = Icons.directions_bus;
        break;
      case "Taxi":
        transportIcon = Icons.local_taxi;
        break;
      case "By Legs":
        transportIcon = Icons.directions_walk;
        break;
      default:
        transportIcon = Icons.directions;
    }
  }

  return GestureDetector(
    onTap: () {
      showTransportChoices(context, dayIndex, transportIndex, updateTransport);
    },
    child: Row(
      children: [
        Container(
          width: 20,
          child: Center(
            child: Container(
              width: 2,
              height: 60,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: transport.isEmpty ? Colors.grey.shade50 : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: transport.isEmpty ? Colors.grey.shade300 : Colors.blue.shade200,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  transportIcon,
                  size: 18,
                  color: transport.isEmpty ? Colors.grey.shade400 : Colors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  transportText,
                  style: TextStyle(
                    color: transport.isEmpty ? Colors.grey.shade500 : Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget to build empty transport timeline item
Widget buildEmptyTransportTimelineItem(BuildContext context, int transportIndex, int dayIndex, Function(int, int, String) updateTransport) {
  return buildTransportTimelineItem(context, transportIndex, "", dayIndex, updateTransport);
}

// Shows the transport selection dialog
void showTransportChoices(BuildContext context, int dayIndex, int transportIndex, Function(int, int, String) updateTransport) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title and close button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Choose Your Transport",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Car option
          TransportOption(
            icon: 'assets/carr.png',
            name: 'Car',
            distance: '12Km',
            duration: '20min',
            price: '\$20',
            people: 4,
            isSelected: true,
            onTap: () {
              updateTransport(dayIndex, transportIndex, "Car");
              Navigator.pop(context);
            },
          ),
          
          // Bus option
          TransportOption(
            icon: 'assets/buss.png',
            name: 'Bus',
            distance: '12Km',
            duration: '25min',
            price: '\$5',
            people: 10,
            onTap: () {
              updateTransport(dayIndex, transportIndex, "Bus");
              Navigator.pop(context);
            },
          ),
          
          // Taxi/Tuk option
          TransportOption(
            icon: 'assets/taxi.png',
            name: 'Tuk',
            distance: '12Km',
            duration: '28min',
            price: '\$15',
            people: 3,
            onTap: () {
              updateTransport(dayIndex, transportIndex, "Taxi");
              Navigator.pop(context);
            },
          ),
          
          // Walking option
          TransportOption(
            icon: 'assets/walk.png',
            name: 'By Legs',
            distance: '12Km',
            duration: '60min',
            price: null, // No price for walking
            people: 1,
            onTap: () {
              updateTransport(dayIndex, transportIndex, "By Legs");
              Navigator.pop(context);
            },
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}

// Restaurant list screen
class RestaurantListScreen extends StatelessWidget {
  final Function(String) onSelect;
  
  const RestaurantListScreen({Key? key, required this.onSelect}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Restaurant'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No restaurants available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.restaurant, color: Colors.blue),
                  title: Text(snapshot.data![index]),
                  onTap: () {
                    onSelect(snapshot.data![index]);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
  
  Future<List<String>> fetchRestaurants() async {
    // This would normally be an API call
    // For now, returning mock data
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      'Beach Restaurant',
      'Sunset Café',
      'Mountain View Bistro',
      'Ocean Breeze Restaurant',
      'Local Cuisine Experience'
    ];
  }
}

// Hotel list screen
class HotelListScreen extends StatelessWidget {
  final Function(String) onSelect;
  
  const HotelListScreen({Key? key, required this.onSelect}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Hotel'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchHotels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hotels available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.hotel, color: Colors.blue),
                  title: Text(snapshot.data![index]),
                  onTap: () {
                    onSelect(snapshot.data![index]);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
  
  Future<List<String>> fetchHotels() async {
    // This would normally be an API call
    // For now, returning mock data
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      'Luxury Resort & Spa',
      'Beach View Hotel',
      'City Center Suites',
      'Mountain Lodge',
      'Budget Inn'
    ];
  }
}

// Activity list screen
class ActivityListScreen extends StatelessWidget {
  final Function(String) onSelect;
  
  const ActivityListScreen({Key? key, required this.onSelect}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Activity'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No activities available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.local_activity, color: Colors.blue),
                  title: Text(snapshot.data![index]),
                  onTap: () {
                    onSelect(snapshot.data![index]);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
  
  Future<List<String>> fetchActivities() async {
    // This would normally be an API call
    // For now, returning mock data
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      'Beach Surfing',
      'Hiking Tour',
      'City Museum Visit',
      'Local Market Tour',
      'Boat Cruise',
      'Sunset Photography'
    ];
  }
}

// Transport option widget for the dialog
class TransportOption extends StatelessWidget {
  final String icon;
  final String name;
  final String distance;
  final String duration;
  final String? price;
  final int people;
  final bool isSelected;
  final VoidCallback onTap;

  const TransportOption({
    Key? key,
    required this.icon,
    required this.name,
    required this.distance,
    required this.duration,
    this.price,
    required this.people,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            // Transport icon
            Image.asset(
              icon,
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 16),
            
            // Transport details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Stats
                  Row(
                    children: [
                      // Duration
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      
                      // Distance
                      Row(
                        children: [
                          Icon(
                            Icons.straighten,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            distance,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      
                      // People
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$people",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Price
            if (price != null)
              Text(
                price!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            else
              Text(
                "Free",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green.shade600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}