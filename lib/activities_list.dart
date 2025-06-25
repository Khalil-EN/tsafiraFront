import 'package:flutter/material.dart';
import 'activities_search.dart';
import 'activities_details.dart';
import "services/api.dart";
import 'login.dart';
import 'exceptions/session_expired_exception.dart';

class ActivitiesPage extends StatefulWidget {
  final bool isFromSearch;
  final List<String>? activityTypes;
  final DateTime? date;
  final String location;
  final TimeOfDay? time;
  final int participants;
  final bool freeOnly;
  final List<String>? ageGroups;
  final List<String>? specialRequirements;

  const ActivitiesPage({
    Key? key,
    this.isFromSearch = false,
    this.location = "",
    this.activityTypes,
    this.date,
    this.time,
    this.participants = 0,
    this.specialRequirements,
    this.ageGroups,
    this.freeOnly = false,
  }) : super(key: key);
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  // Example activities list
  List<Map<String, dynamic>> activities2 = [];
  bool isLoading = true;
  final List<Map<String, dynamic>> activities = [
    {
      "title": "Family Fun Center",
      "image": "assets/Activities1.jpg",
      "price": "\$\$",
      "color": Colors.blue,
      "features": ["Kid-Friendly Activities", "Multiple Game Zones"],
      "chip": "Group Discounts",
    },
    {
      "title": "Extreme Adventure Park",
      "image": "assets/Activities1.jpg",
      "price": "\$\$\$",
      "color": Colors.orange,
      "features": ["Outdoor Challenges", "Adrenaline Rush"],
      "chip": "Peak Season",
    },
    {
      "title": "Zen Wellness Retreat",
      "image": "assets/Activities1.jpg",
      "price": "\$\$\$\$",
      "color": Colors.purple,
      "features": ["Relaxation Therapies"],
      "chip": "Premium Experience",
    },
  ];
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      var _activities;
      if(widget.isFromSearch){
        var pdata = {"date": widget.date, "time": widget.time, "freeOnly": widget.freeOnly, "location": widget.location, "activityTypes": widget.activityTypes,"specialRequirements": widget.specialRequirements,"ageGroups": widget.ageGroups,"participants": widget.participants};
        _activities = await Api.searchActivities(pdata);
      }else{
        _activities = await Api.fetchActivities();
      }
      setState(() {
        activities2 = _activities;
        isLoading = false;
      });
    } on SessionExpiredException {
      // Redirect to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login(showSessionExpired: true,)),
      );
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(
          child: Text(
            'Activities',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchActivities()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: activities2.length,
        itemBuilder: (context, index) {
          final activity = activities2[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ActivityDetails(activityName: activity['name'],
                      location: activity['location'],
                      //price: restaurant['price'],
                      rating: activity['rating'],
                      imageUrl: activity['imageurl'],
                      reviews: activity['reviews'],
                      type: activity['type'],
                      //description: restaurant['description'],
                      //facilities: Facilities,
                    )),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          activity["imageurl"],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Content
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              activity["name"],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 12),

                            // Features
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: ["Outdoor Challenges", "Adrenaline Rush"]
                                  .map<Widget>((feature) => Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.blue, size: 20),
                                  SizedBox(width: 8),
                                  Text(feature),
                                ],
                              ))
                                  .toList(),
                            ),

                            SizedBox(height: 16),

                            // Price & Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text('View details'),
                                  backgroundColor: Colors.blue.withOpacity(0.1),
                                  labelStyle: TextStyle(color: Colors.blue),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ActivityDetails(activityName: activity['name'],
                                        location: activity['location'],
                                        //price: restaurant['price'],
                                        rating: activity['rating'],
                                        imageUrl: activity['imageurl'],
                                        reviews: activity['reviews'],
                                        type: activity['type'],
                                        //description: restaurant['description'],
                                        //facilities: Facilities,
                                      )),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text('Book Now', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
