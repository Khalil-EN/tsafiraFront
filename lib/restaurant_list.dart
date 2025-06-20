import 'package:flutter/material.dart';
import 'restaurant_search.dart';
import 'restaurant_detail.dart';
import 'services/api.dart';
import 'dart:convert';
import 'exceptions/session_expired_exception.dart';
import 'login.dart';


class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {

  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = true;

  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    try {
      final _restaurants = await Api.fetchRestaurants();
      setState(() {
        restaurants = _restaurants;
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

  RangeValues _priceRange = RangeValues(10, 100);
  bool _isOpenNow = false;

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
            'Restaurants',
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
                MaterialPageRoute(builder: (context) => SearchRestaurant()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                String imagesString = restaurant['detailimages'];
                String facilities = restaurant['facilities'];


                String validJsonString = imagesString.replaceAll("'", '"');
                String validJsonString2 = facilities.replaceAll("'", '"');

                List<String> imageUrls = List<String>.from(jsonDecode(validJsonString));
                List<String> Facilities = List<String>.from(jsonDecode(validJsonString2));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RestaurantDetails(restaurantName: restaurant['name'],
                    location: restaurant['location'],
                    price: restaurant['price'],
                    rating: restaurant['rating'],
                    imagesUrl: imageUrls,
                    reviews: restaurant['reviews'],
                    openingHours: restaurant['openingHours'],
                    description: restaurant['description'],
                    facilities: Facilities,)),
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
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        restaurant['imageurl'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.cake, color: Colors.pink, size: 20),
                                      SizedBox(width: 8),
                                      Text('Birthday Party Specialist'),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.accessibility, color: Colors.blue, size: 20),
                                      SizedBox(width: 8),
                                      Text('Kid-Friendly Zones'),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                restaurant['price'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                label: Text('Special Offers'),
                                backgroundColor: Colors.lightBlueAccent,
                                labelStyle: TextStyle(color: Colors.blue),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  //String imagesString = restaurant['detailimages'];
                                  //String facilities = restaurant['facilities'];


                                  //String validJsonString = imagesString.replaceAll("'", '"');
                                  //String validJsonString2 = facilities.replaceAll("'", '"');

                                  List<String> imageUrls = List<String>.from(restaurant['detailimages']);
                                  List<String> Facilities = List<String>.from(restaurant['facilities']);
                                  double zeros = 0.0;
                                  double rating = restaurant['rating'] + zeros;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RestaurantDetails(restaurantName: restaurant['name'],
                                        location: restaurant['location'],
                                        price: restaurant['price'],
                                        rating: rating,
                                        imagesUrl: imageUrls,
                                        reviews: restaurant['reviews'],
                                        openingHours: restaurant['openingHours'],
                                        description: restaurant['description'],
                                        facilities: Facilities,)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'View Details',
                                  style: TextStyle(color: Colors.white),
                                ),
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
          );
        },
      ),
    );
  }
}

  /*void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Price Range Slider
                  Text('Price Range: \$${_priceRange.start.round()} - \$${_priceRange.end.round()}'),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 200,
                    divisions: 20,
                    labels: RangeLabels(
                      '\$${_priceRange.start.round()}', 
                      '\$${_priceRange.end.round()}'
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),

                  // Open Now Switch
                  SwitchListTile(
                    title: Text('Open Now'),
                    value: _isOpenNow,
                    onChanged: (bool value) {
                      setState(() {
                        _isOpenNow = value;
                      });
                    },
                  ),

                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Apply filters logic would go here
                    },
                    child: Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }*/

  /*Widget _buildBirthdayPartyRestaurant(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RestaurantDetails()),
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
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                'assets/Restaurant2.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Party Palace Restaurant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 12),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.cake,
                                color: Colors.pink,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('Birthday Party Specialist'),
                            ],
                          ),
                          
                          SizedBox(height: 8),
                          
                          Row(
                            children: [
                              Icon(
                                Icons.accessibility,
                                color: Colors.blue,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('Kid-Friendly Zones'),
                            ],
                          ),
                        ],
                      ),
                      
                      Text(
                        '\$\$\$',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text('Birthday Packages'),
                        backgroundColor: Colors.pink.shade50,
                        labelStyle: TextStyle(color: Colors.pink),
                      ),
                      
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RestaurantDetails()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Book Party',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetFriendlyRestaurant(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RestaurantDetails()),
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
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                'assets/Restaurant2.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budget Bites Cafe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 12),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: Colors.green,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('Affordable Meals'),
                            ],
                          ),
                          
                          SizedBox(height: 8),
                          
                          Row(
                            children: [
                              Icon(
                                Icons.fastfood,
                                color: Colors.orange,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('Student-Friendly'),
                            ],
                          ),
                        ],
                      ),
                      
                      Text(
                        '\$',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text('Combo Deals'),
                        backgroundColor: Colors.green.shade50,
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                      
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RestaurantDetails()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Order Now',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGourmetExperienceRestaurant(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RestaurantDetails()),
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
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                'assets/Restaurant2.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gourmet Horizon',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 12),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.dining,
                                color: Colors.deepPurple,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('Chef\'s Tasting Menu'),
                            ],
                          ),
                        ],
                      ),
                      
                      Text(
                        '\$\$\$\$',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text('Fine Dining'),
                        backgroundColor: Colors.purple.shade50,
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RestaurantDetails()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Reserve',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/
