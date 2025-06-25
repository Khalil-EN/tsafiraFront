import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "activities_list.dart";

class SearchActivities extends StatefulWidget {
  @override
  _SearchActivitiesState createState() => _SearchActivitiesState();
}

class _SearchActivitiesState extends State<SearchActivities> {
  // Location controller
  TextEditingController _locationController = TextEditingController(text: 'Tetuan, Morocco');

  // Date and Time variables
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Additional search parameters
  int _participantCount = 2;
  bool _onlyFreeBool = false;
  
  // Activity types
  List<String> _activityTypes = [
    'Outdoor', 'Cultural', 'Sports', 'Educational', 
    'Art', 'Music', 'Adventure', 'Family-Friendly', 
    'Fitness', 'Workshop','Beach','Museums'
  ];
  List<String> _selectedActivityTypes = [];

  // Age groups
  List<String> _ageGroups = [
    'Kids', 'Teenagers', 'Adults', 'Seniors', 'All Ages'
  ];
  List<String> _selectedAgeGroups = [];

  // Special requirements
  List<String> _specialRequirements = [
    'Wheelchair Accessible', 'Pet-Friendly', 'Beginner-Friendly', 
    'No Experience Needed', 'Indoor', 'Outdoor'
  ];
  List<String> _selectedSpecialRequirements = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Search Activities',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Location
                SizedBox(height: 10),
                Text(
                  'Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Date and Time Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text(DateFormat('dd MMM').format(_selectedDate)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text(_selectedTime.format(context)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Participants
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Participants',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, color: Colors.blue),
                                  onPressed: () {
                                    if (_participantCount > 1) {
                                      setState(() {
                                        _participantCount--;
                                      });
                                    }
                                  },
                                ),
                                Text('$_participantCount'),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      _participantCount++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Free Activities Toggle
                SwitchListTile(
                  title: Text('Free Activities Only'),
                  value: _onlyFreeBool,
                  onChanged: (bool value) {
                    setState(() {
                      _onlyFreeBool = value;
                    });
                  },
                ),

                SizedBox(height: 20),

                // Activity Types
                Text(
                  'Activity Types',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _activityTypes.map((activity) {
                    return FilterChip(
                      label: Text(activity),
                      selected: _selectedActivityTypes.contains(activity),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedActivityTypes.add(activity);
                          } else {
                            _selectedActivityTypes.remove(activity);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                SizedBox(height: 20),

                // Age Groups
                Text(
                  'Age Groups',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _ageGroups.map((ageGroup) {
                    return FilterChip(
                      label: Text(ageGroup),
                      selected: _selectedAgeGroups.contains(ageGroup),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedAgeGroups.add(ageGroup);
                          } else {
                            _selectedAgeGroups.remove(ageGroup);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                SizedBox(height: 20),

                // Special Requirements
                Text(
                  'Special Requirements',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _specialRequirements.map((requirement) {
                    return FilterChip(
                      label: Text(requirement),
                      selected: _selectedSpecialRequirements.contains(requirement),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedSpecialRequirements.add(requirement);
                          } else {
                            _selectedSpecialRequirements.remove(requirement);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                SizedBox(height: 30),

                // Search Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ActivitiesPage(isFromSearch: true,
                          location: _locationController.text,
                          date: _selectedDate,
                          time: _selectedTime,
                          participants: _participantCount,
                          freeOnly: _onlyFreeBool,
                          activityTypes: _selectedActivityTypes,
                          ageGroups: _selectedAgeGroups,
                          specialRequirements: _selectedSpecialRequirements,)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Search Activities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _performSearch() {
    // Gather all search parameters
    final searchParams = {
      'location': _locationController.text,
      'date': _selectedDate,
      'time': _selectedTime,
      'participants': _participantCount,
      'freeOnly': _onlyFreeBool,
      'activityTypes': _selectedActivityTypes,
      'ageGroups': _selectedAgeGroups,
      'specialRequirements': _selectedSpecialRequirements,
    };

    // TODO: Implement actual search logic
    print('Search Parameters: $searchParams');
    // Navigate to search results or perform filtering
  }
}