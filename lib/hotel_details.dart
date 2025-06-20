import 'package:flutter/material.dart';

class HotelDetails extends StatefulWidget {
  final String hotelName;
  final String location;
  final int price;
  final double rating;
  final int reviews;
  final String description;
  final List<String> imageUrls;
  final List<String> amenities;

  HotelDetails({
    required this.hotelName,
    required this.location,
    required this.price,
    required this.rating,
    required this.imageUrls,
    required this.amenities,
    required this.reviews,
    required this.description,
  });

  @override
  _HotelDetailsState createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  final List<String> hotelImages = [
    'assets/hotel1.png',
    'assets/hotel2.png',
    'assets/hotel3.png',
    'assets/hotel4.png',
    'assets/hotel5.png'
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    print(widget.imageUrls);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                      itemCount: widget.imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          _current = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.imageUrls[index],
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
                      children: widget.imageUrls.asMap().entries.map((entry) {
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

              // Rest of the code remains the same
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Name and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Hotel Name with text wrapping
                        Expanded(
                          child: Text(
                            widget.hotelName,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,  // Optionally add ellipsis if it overflows
                            maxLines: 2,  // Limit to 2 lines if needed
                            softWrap: true,  // Allow soft wrapping
                          ),
                        ),
                        Text(
                          '~ ${widget.price} MAD',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
// Location with text wrapping
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.location,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                            overflow: TextOverflow.ellipsis,  // Optionally add ellipsis if it overflows
                            maxLines: 2,  // Limit to 2 lines if needed
                            softWrap: true,  // Allow soft wrapping
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '${widget.rating} (${widget.reviews})',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // About Section
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
                      onPressed: () {
                        // Implement read more functionality
                      },
                      child: Text(
                        'Read More...',
                        style: TextStyle(color: Colors.blue),
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
                    Column( crossAxisAlignment: CrossAxisAlignment.start, children: (widget.amenities ?? []).map((amenity) => _buildFacilityRow(amenity)).toList(), ),

                    SizedBox(height: 16),

                    // Select a Room Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement room selection
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Select a Room',
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
      ),
    );
  }

  Widget _buildFacilityRow(String facility) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.blue, size: 20),
          SizedBox(width: 8),
          Text(facility),
        ],
      ),
    );
  }
}