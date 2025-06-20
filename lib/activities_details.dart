import 'package:flutter/material.dart';

class ActivityDetails extends StatefulWidget {
  final String activityName;
  final String location;
  //final String price;
  final double rating;
  final int reviews;
  final String type;
  final String imageUrl;
  //final List<String> facilities;
  //final String description;

  ActivityDetails({
    required this.activityName,
    required this.location,
    //required this.price,
    required this.rating,
    required this.imageUrl,
    //required this.facilities,
    required this.reviews,
    required this.type,
    //required this.description,
  });
  @override
  _ActivityDetailsState createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  final List<String> activityImages = [
    'assets/Activities1.jpg',
    'assets/Activities1.jpg',
    'assets/Activities1.jpg',
    'assets/Activities1.jpg',
    'assets/Activities1.jpg'
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
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
                      itemCount: 1,
                      onPageChanged: (index) {
                        setState(() {
                          _current = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.imageUrl,
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
                      children: activityImages.asMap().entries.map((entry) {
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
                    // Activity Name and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.activityName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Free',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          widget.location,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.green, size: 20),
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
                      widget.type,
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        // Implement read more functionality
                      },
                      child: Text(
                        'Read More...',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Activity Details
                    Text(
                      'Activity Highlights',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        _buildHighlightRow('Professional Guide Included'),
                        _buildHighlightRow('Suitable for All Fitness Levels'),
                        _buildHighlightRow('Scenic Photo Opportunities'),
                        _buildHighlightRow('Picnic Lunch Provided'),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Schedule and Timing
                    Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        _buildScheduleRow('Departure Time', '8:00 AM'),
                        _buildScheduleRow('Duration', '6-7 Hours'),
                        _buildScheduleRow('Days Available', 'Every Weekend'),
                        _buildScheduleRow('Group Size', 'Max 15 Participants'),
                      ],
                    ),

                    SizedBox(height: 16),

                    // What to Bring
                    Text(
                      'What to Bring',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        _buildBringRow('Comfortable Hiking Shoes'),
                        _buildBringRow('Water Bottle'),
                        _buildBringRow('Sunscreen'),
                        _buildBringRow('Light Jacket'),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Book Activity Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement activity booking
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Book this Activity',
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

  Widget _buildHighlightRow(String highlight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Text(highlight),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBringRow(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Text(item),
        ],
      ),
    );
  }
}