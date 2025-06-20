import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantDetails extends StatefulWidget {
  final String restaurantName;
  final String location;
  final String price;
  final double rating;
  final int reviews;
  final String openingHours;
  final List<String> imagesUrl;
  final List<String> facilities;
  final String description;

  RestaurantDetails({
    required this.restaurantName,
    required this.location,
    required this.price,
    required this.rating,
    required this.imagesUrl,
    required this.facilities,
    required this.reviews,
    required this.openingHours,
    required this.description,
  });

  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  List<String> filteredImages = [];
  bool isLoading = true;
  int _current = 0;

  /*@override
  void initState() {
    super.initState();
    sendImagesToFlask();
  }

  Future<void> sendImagesToFlask() async {
    final url = Uri.parse('http://10.0.2.2:5001/filter-images');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'images': widget.imagesUrl}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        List<String> newImages = [];
        for (var item in result['relevant_images']) {
          if (item['relevant'] == true) {
            newImages.add(item['url']);
          }
        }
        setState(() {
          filteredImages = newImages;
          isLoading = false;
        });
      } else {
        print('Failed to get response: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error sending images: $e');
      setState(() {
        isLoading = false;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final imageList = widget.imagesUrl;

    return Scaffold(
      body:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel
              Stack(
                children: [
                  SizedBox(
                    height: 350,
                    width: double.infinity,
                    child: PageView.builder(
                      itemCount: imageList.length,
                      onPageChanged: (index) {
                        setState(() {
                          _current = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          imageList[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                  // Back Button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  // Image Indicators
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.asMap().entries.map((entry) {
                        return Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == entry.key
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.restaurantName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.price,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.deepPurple, size: 20),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.location,
                            style: TextStyle(color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.deepPurple, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '${widget.rating} (${widget.reviews})',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // About
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Read More...',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Facilities
                    Text(
                      'Facilities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: List.generate(
                        widget.facilities.length,
                            (index) => _buildSpecialtyRow(widget.facilities[index]),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Operating Hours
                    Text(
                      'Operating Hours',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildHoursRow('Monday - Sunday', widget.openingHours),
                    SizedBox(height: 16),
                    // Book Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Book a Table',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

    );
  }

  Widget _buildSpecialtyRow(String specialty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.deepPurple, size: 20),
          SizedBox(width: 8),
          Text(specialty),
        ],
      ),
    );
  }

  Widget _buildHoursRow(String days, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(days, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(hours, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
