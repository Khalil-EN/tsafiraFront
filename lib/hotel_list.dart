import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'hotel_details.dart';
import 'search_hotel.dart';
import 'services/api.dart';
import 'dart:convert';
import 'exceptions/session_expired_exception.dart';
import 'login.dart';


class HotelsPage extends StatefulWidget {
  final bool isFromSearch;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String location;
  final double minPrice;
  final double maxPrice;

  const HotelsPage({
    Key? key,
    this.isFromSearch = false,
    this.location = "",
    this.checkInDate,
    this.checkOutDate,
    this.minPrice = 0,
    this.maxPrice = 0,
  }) : super(key: key);

  @override
  _HotelsPageState createState() => _HotelsPageState();
}


class _HotelsPageState extends State<HotelsPage> {
  List<Map<String, dynamic>> hotels = [];
  bool isLoading = true;

  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    try {
      var _hotels;
      if(widget.isFromSearch){
        var pdata = {"checkInDate": widget.checkInDate, "checkOutDate": widget.checkOutDate, "minPrice": widget.minPrice, "maxPrice": widget.maxPrice, "location": widget.location};
        _hotels = await Api.searchHotels(pdata);
      }else{
        _hotels = await Api.fetchHotels();
      }
      print(_hotels);
      setState(() {
        hotels = _hotels;
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
            'Search Hotels',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchHotel()));
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: _hotelCard(context, hotels[index]),
          );
        },
      ),
    );
  }

  Widget _hotelCard(BuildContext context, Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () {

        String imagesString = hotel['detailimages'];
        String amenitiesString = hotel['amenities'];// This is the raw string


        String validJsonString = imagesString.replaceAll("'", '"');
        String validJsonString2 = amenitiesString.replaceAll("'", '"');

        List<String> imageUrls = List<String>.from(jsonDecode(validJsonString));
        List<String> amenities = List<String>.from(jsonDecode(validJsonString2));
        print(hotel);
        print(amenities);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HotelDetails(hotelName: hotel['name'],
            location: hotel['location'],
            price: hotel['price'],
            rating: hotel['rating'],
            imageUrls: imageUrls,
            reviews: hotel['reviews'],
            description: hotel['description'],
            amenities: amenities,)),
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
                hotel['imageurl'] ?? 'https://via.placeholder.com/200',
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
                    hotel['name'] ?? 'Unknown Hotel',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),

                  // Room and Guest Details with Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Room and Guests
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.bed,
                                color: Color.fromARGB(255, 33, 150, 243),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('01 Room'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: Color.fromARGB(255, 33, 150, 243),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('02 Guests'),
                            ],
                          ),
                        ],
                      ),

                      // Price
                      Text(
                        '~ ${hotel['price']} MAD',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // View More Details and Select Room
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // View More Details (Left, Bold)
                      Text(
                        'View More Details',
                        style: TextStyle(
                          color: Color.fromARGB(255, 33, 150, 243),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Select Room (Right, Blue Button with White Text)
                      ElevatedButton(
                        onPressed: () {

                          //String facilities = restaurant['facilities'];



                          //String validJsonString2 = facilities.replaceAll("'", '"');
                          print(hotel);

                          List<String> imageUrls = List<String>.from(hotel['detailimages']);
                          List<String> amenities = List<String>.from(hotel['amenities'] ?? ['Missing']);

                          //List<String> Facilities = List<String>.from(jsonDecode(validJsonString2));
                          // Navigate to HotelDetails when Select Room is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HotelDetails(hotelName: hotel['name'],
                              location: hotel['location'],
                              price: hotel['price'],
                              rating: hotel['rating'],
                              imageUrls: imageUrls,
                              reviews: hotel['reviews'],
                              description: hotel['description'],
                              amenities: amenities,)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 33, 150, 243),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Select Room',
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
}