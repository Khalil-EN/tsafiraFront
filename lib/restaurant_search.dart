import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchRestaurant extends StatefulWidget {
  @override
  _SearchRestaurantState createState() => _SearchRestaurantState();
}

class _SearchRestaurantState extends State<SearchRestaurant> {
  // Location controller
  TextEditingController _locationController = TextEditingController(text: 'Tetuan, Morocco');

  // Date and Time variables
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Additional search parameters
  int _guestCount = 2;
  RangeValues _priceRange = RangeValues(10, 100);
  
  // Cuisine type selection
  List<String> _cuisineTypes = [
    'Italian', 'Mexican', 'Chinese', 'Indian', 
    'Seafood', 'Vegetarian', 'BBQ', 'Fast Food'
  ];
  List<String> _selectedCuisines = [];

  // Dietary restrictions
  List<String> _dietaryOptions = [
    'Vegetarian', 'Vegan', 'Gluten-Free', 'Halal', 'Kosher'
  ];
  List<String> _selectedDietaryOptions = [];

  // Special features
  List<String> _specialFeatures = [
    'Outdoor Seating', 'Live Music', 'Family-Friendly', 
    'Romantic', 'Wi-Fi', 'Takeout', 'Delivery'
  ];
  List<String> _selectedSpecialFeatures = [];

  @override
  void initState() {
    super.initState();
    // Initialize price range controllers
    _minPriceController.text = _priceRange.start.round().toString();
    _maxPriceController.text = _priceRange.end.round().toString();
  }

  // Price range controllers
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

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
          'Search Restaurant',
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

                // Guests
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guests',
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
                                    if (_guestCount > 1) {
                                      setState(() {
                                        _guestCount--;
                                      });
                                    }
                                  },
                                ),
                                Text('$_guestCount'),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      _guestCount++;
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

                // Price Range
                Text(
                  'Price Range',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _minPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Min',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          ),
                          onChanged: (value) {
                            double newMin = double.tryParse(value) ?? _priceRange.start;
                            setState(() {
                              _priceRange = RangeValues(
                                newMin.clamp(0, 200),
                                _priceRange.end,
                              );
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 200,
                        divisions: 20,
                        labels: RangeLabels(
                          '\$${_priceRange.start.round()}', 
                          '\$${_priceRange.end.round()}'
                        ),
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue.shade100,
                        onChanged: (RangeValues values) {
                          setState(() {
                            _priceRange = values;
                            _minPriceController.text = _priceRange.start.round().toString();
                            _maxPriceController.text = _priceRange.end.round().toString();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _maxPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Max',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          ),
                          onChanged: (value) {
                            double newMax = double.tryParse(value) ?? _priceRange.end;
                            setState(() {
                              _priceRange = RangeValues(
                                _priceRange.start,
                                newMax.clamp(0, 200),
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Cuisine Types
                Text(
                  'Cuisine Types',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _cuisineTypes.map((cuisine) {
                    return FilterChip(
                      label: Text(cuisine),
                      selected: _selectedCuisines.contains(cuisine),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedCuisines.add(cuisine);
                          } else {
                            _selectedCuisines.remove(cuisine);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                SizedBox(height: 20),

                // Dietary Options
                Text(
                  'Dietary Options',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _dietaryOptions.map((diet) {
                    return FilterChip(
                      label: Text(diet),
                      selected: _selectedDietaryOptions.contains(diet),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedDietaryOptions.add(diet);
                          } else {
                            _selectedDietaryOptions.remove(diet);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                SizedBox(height: 20),

                // Special Features
                Text(
                  'Special Features',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _specialFeatures.map((feature) {
                    return FilterChip(
                      label: Text(feature),
                      selected: _selectedSpecialFeatures.contains(feature),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedSpecialFeatures.add(feature);
                          } else {
                            _selectedSpecialFeatures.remove(feature);
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
                      // Implement search functionality
                      _performSearch();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Search Restaurants',
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
      'guests': _guestCount,
      'priceMin': _priceRange.start,
      'priceMax': _priceRange.end,
      'cuisines': _selectedCuisines,
      'dietaryOptions': _selectedDietaryOptions,
      'specialFeatures': _selectedSpecialFeatures,
    };

    // TODO: Implement actual search logic
    print('Search Parameters: $searchParams');
    // Navigate to search results or perform filtering
  }
}