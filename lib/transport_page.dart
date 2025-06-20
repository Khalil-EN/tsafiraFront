import 'package:flutter/material.dart';

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

// Helper widget for transport options
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            // Transport icon
            Image.asset(
              icon,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            
            // Transport details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$distance · $duration',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Price and capacity
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (price != null)
                  Text(
                    price!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                else
                  const Text(
                    'Free',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'x$people',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to build transport timeline item
Widget buildTransportTimelineItem(BuildContext context, int index, String transport, int dayIndex, Function(int, int, String) updateTransport) {
  IconData transportIcon;
  String transportName = transport.isEmpty ? "Select Transport" : transport;
  
  // Determine icon based on transport type
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
      transportIcon = Icons.sync_alt;
  }
  
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Timeline (no dot)
      const SizedBox(width: 30),
      
      const SizedBox(width: 15),
      
      // Transport card
      Expanded(
        child: GestureDetector(
          onTap: () => showTransportChoices(context, dayIndex, index, updateTransport),
          child: Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: transport.isEmpty ? Colors.grey.shade300 : Colors.blue.shade200,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Icon(
                    transportIcon,
                    color: transport.isEmpty ? Colors.grey : Colors.blue,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    transportName,
                    style: TextStyle(
                      color: transport.isEmpty ? Colors.grey : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

// Widget to build empty transport timeline item
Widget buildEmptyTransportTimelineItem(BuildContext context, int index, int dayIndex, Function(int, int, String) updateTransport) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Timeline with space (no dot)
      const SizedBox(width: 30),
      
      const SizedBox(width: 15),
      // Empty transport indicator
      Expanded(
        child: GestureDetector(
          onTap: () => showTransportChoices(context, dayIndex, index, updateTransport),
          child: Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: const Center(
              child: Text(
                'Select Transport',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

abstract class AttractionListScreen extends StatefulWidget {
  final Function(String) onSelect;
  
  const AttractionListScreen({Key? key, required this.onSelect}) : super(key: key);
}

// Restaurant selection screen
class RestaurantListScreen extends AttractionListScreen {
  const RestaurantListScreen({Key? key, required Function(String) onSelect}) 
      : super(key: key, onSelect: onSelect);

  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }
  
  Future<void> fetchRestaurants() async {
    // In a real app, you would fetch from an API
    // Simulating API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      restaurants = [
        {
          "id": "1",
          "name": "Ocean View Restaurant",
          "rating": 4.5,
          "image": "assets/restaurant1.jpg",
          "price": "\$\$",
          "cuisine": "Seafood",
          "distance": "0.5 km"
        },
        {
          "id": "2",
          "name": "Mountain Cafe",
          "rating": 4.2,
          "image": "assets/restaurant2.jpg",
          "price": "\$",
          "cuisine": "Coffee & Breakfast",
          "distance": "1.2 km"
        },
        {
          "id": "3",
          "name": "Local Cuisine",
          "rating": 4.7,
          "image": "assets/restaurant3.jpg",
          "price": "\$\$\$",
          "cuisine": "Traditional",
          "distance": "0.8 km"
        },
        {
          "id": "4",
          "name": "Street Food Corner",
          "rating": 4.0,
          "image": "assets/restaurant4.jpg",
          "price": "\$",
          "cuisine": "Various",
          "distance": "1.5 km"
        },
      ];
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Restaurant'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return AttractionListItem(
                  name: restaurant["name"],
                  rating: restaurant["rating"],
                  image: restaurant["image"],
                  details: "${restaurant["cuisine"]} · ${restaurant["price"]} · ${restaurant["distance"]}",
                  onSelect: () {
                    widget.onSelect(restaurant["name"]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
    );
  }
}

// Hotel selection screen
class HotelListScreen extends AttractionListScreen {
  const HotelListScreen({Key? key, required Function(String) onSelect})
      : super(key: key, onSelect: onSelect);

  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  List<Map<String, dynamic>> hotels = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    fetchHotels();
  }
  
  Future<void> fetchHotels() async {
    // In a real app, you would fetch from an API
    // Simulating API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      hotels = [
        {
          "id": "1",
          "name": "Grand Resort & Spa",
          "rating": 4.8,
          "image": "assets/hotel1.jpg",
          "price": "\$\$\$",
          "facilities": "Pool, Spa, Restaurant",
          "distance": "0.3 km from beach"
        },
        {
          "id": "2",
          "name": "Cozy Inn",
          "rating": 4.3,
          "image": "assets/hotel2.jpg",
          "price": "\$\$",
          "facilities": "Breakfast, Parking",
          "distance": "1.0 km from center"
        },
        {
          "id": "3",
          "name": "Luxury Suites",
          "rating": 4.9,
          "image": "assets/hotel3.jpg",
          "price": "\$\$\$\$",
          "facilities": "All-inclusive, Pool, Spa",
          "distance": "0.5 km from beach"
        },
        {
          "id": "4",
          "name": "Budget Stay",
          "rating": 3.8,
          "image": "assets/hotel4.jpg",
          "price": "\$",
          "facilities": "Breakfast",
          "distance": "2.0 km from center"
        },
      ];
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Hotel'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return AttractionListItem(
                  name: hotel["name"],
                  rating: hotel["rating"],
                  image: hotel["image"],
                  details: "${hotel["facilities"]} · ${hotel["price"]} · ${hotel["distance"]}",
                  onSelect: () {
                    widget.onSelect(hotel["name"]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
    );
  }
}

// Activity selection screen
class ActivityListScreen extends AttractionListScreen {
  const ActivityListScreen({Key? key, required Function(String) onSelect})
      : super(key: key, onSelect: onSelect);

  @override
  _ActivityListScreenState createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  List<Map<String, dynamic>> activities = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    fetchActivities();
  }
  
  Future<void> fetchActivities() async {
    // In a real app, you would fetch from an API
    // Simulating API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      activities = [
        {
          "id": "1",
          "name": "Beach Surfing",
          "rating": 4.6,
          "image": "assets/activity1.jpg",
          "price": "\$\$",
          "duration": "2 hours",
          "distance": "At beach"
        },
        {
          "id": "2",
          "name": "City Tour",
          "rating": 4.4,
          "image": "assets/activity2.jpg",
          "price": "\$",
          "duration": "3 hours",
          "distance": "Starts at center"
        },
        {
          "id": "3",
          "name": "Scuba Diving",
          "rating": 4.8,
          "image": "assets/activity3.jpg",
          "price": "\$\$\$",
          "duration": "4 hours",
          "distance": "5 km"
        },
        {
          "id": "4",
          "name": "Hiking Adventure",
          "rating": 4.5,
          "image": "assets/activity4.jpg",
          "price": "\$",
          "duration": "6 hours",
          "distance": "10 km"
        },
        {
          "id": "5",
          "name": "Local Museum",
          "rating": 4.2,
          "image": "assets/activity5.jpg",
          "price": "\$",
          "duration": "1.5 hours",
          "distance": "1.2 km"
        },
      ];
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Activity'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return AttractionListItem(
                  name: activity["name"],
                  rating: activity["rating"],
                  image: activity["image"],
                  details: "${activity["duration"]} · ${activity["price"]} · ${activity["distance"]}",
                  onSelect: () {
                    widget.onSelect(activity["name"]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
    );
  }
}

// Reusable list item widget for attractions
class AttractionListItem extends StatelessWidget {
  final String name;
  final double rating;
  final String image;
  final String details;
  final VoidCallback onSelect;

  const AttractionListItem({
    Key? key,
    required this.name,
    required this.rating,
    required this.image,
    required this.details,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image with fallback
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Fallback color if image fails to load
                  },
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  color: Colors.blue.withOpacity(0.1),
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Details
                    Text(
                      details,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Select button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: onSelect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(80, 32),
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                        child: const Text('Select'),
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