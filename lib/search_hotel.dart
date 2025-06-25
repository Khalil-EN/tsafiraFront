import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar_example/hotel_list.dart';
import 'services/api.dart';

class SearchHotel extends StatefulWidget {
  @override
  _SearchHotelState createState() => _SearchHotelState();
}

class _SearchHotelState extends State<SearchHotel> {
  // Location controller
  TextEditingController _locationController = TextEditingController(text: 'City, country');

  // Date variables
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(Duration(days: 2));

  // Guest and Room variables
  int _guestCount = 2;
  int _roomCount = 1;

  // Money range
  RangeValues _moneyRange = RangeValues(50, 200);
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with initial range values
    _minPriceController.text = _moneyRange.start.round().toString();
    _maxPriceController.text = _moneyRange.end.round().toString();
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
        title: Text(
          'Search Hotel',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center( // Wrap with Center widget
        child: SingleChildScrollView( // Add scrolling capability
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center align
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
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

                SizedBox(height: 20), // Increased spacing

                // Check In and Check Out
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _selectDate(context, isCheckIn: true),
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
                                  Text(DateFormat('dd MMM').format(_checkInDate)),
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
                            'Check Out',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _selectDate(context, isCheckIn: false),
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
                                  Text(DateFormat('dd MMM').format(_checkOutDate)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20), // Increased spacing

                // Guests and Rooms
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
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rooms',
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
                                    if (_roomCount > 1) {
                                      setState(() {
                                        _roomCount--;
                                      });
                                    }
                                  },
                                ),
                                Text('$_roomCount'),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      _roomCount++;
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

                SizedBox(height: 20), // Increased spacing

                // Money Range
                Text(
                  'Money',
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
                            double newMin = double.tryParse(value) ?? _moneyRange.start;
                            setState(() {
                              _moneyRange = RangeValues(
                                newMin.clamp(0, 1000),
                                _moneyRange.end,
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
                        values: _moneyRange,
                        min: 0,
                        max: 1000,
                        divisions: 30,
                        labels: RangeLabels(
                          '${_moneyRange.start.round()} Dhs',
                          '${_moneyRange.end.round()} Dhs',
                        ),
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue.shade100,
                        onChanged: (RangeValues values) {
                          setState(() {
                            _moneyRange = values;
                            _minPriceController.text = _moneyRange.start.round().toString();
                            _maxPriceController.text = _moneyRange.end.round().toString();
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
                            double newMax = double.tryParse(value) ?? _moneyRange.end;
                            setState(() {
                              _moneyRange = RangeValues(
                                _moneyRange.start,
                                newMax.clamp(0, 1000),
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30), // Increased spacing before search button

                // Search Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      //var pdata = {"checkInDate": _checkInDate, "checkOutDate": _checkOutDate, "minPrice": _minPriceController, "maxPrice": _maxPriceController, "location": _locationController};
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HotelsPage(isFromSearch: true,
                          checkInDate: _checkInDate,
                          checkOutDate: _checkOutDate,
                          minPrice: _moneyRange.start,
                          maxPrice: _moneyRange.end,
                          location: "Rabat",)),
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
                      'Search',
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

  Future<void> _selectDate(BuildContext context, {required bool isCheckIn}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }
}