import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CategoriesScreen(),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Categories',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.black,
            fontWeight: FontWeight.normal, // Not bold
          ),
        ),
        centerTitle: true, // Center the title
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16), // Adjusted padding
        children: [
          buildCategoryItem('Images/1.png', 'Res'),
          buildCategoryItem('Images/2.png', 'Beach'),
          buildCategoryItem('Images/lake.png', 'Lakes'),
          buildCategoryItem('Images/3.png', 'Camp'),
          buildCategoryItem('Images/zoo.png', 'Zoo'),
          buildCategoryItem('Images/museum.png', 'Museum'),
          buildCategoryItem('Images/amusement_park.png', 'Amusement Park'),
          buildCategoryItem('Images/activities.png', 'Activities'),
          buildCategoryItem('Images/cinema.png', 'Cinema'),
          buildCategoryItem('Images/buses.png', 'city sightseeing bus.'),
          buildCategoryItem('Images/entertainment.png', 'Entertainment'),
        ],
      ),
    );
  }

  Widget buildCategoryItem(String imageUrl, String label) {
    return Container(
      margin: EdgeInsets.only(bottom: 16), // Space between items
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(4, 8),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Image.network(
          imageUrl,
          width: 40,
          height: 40,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal, // Not bold
            fontSize: 14,
            color: Color(0xFF696969),
          ),
        ),
      ),
    );
  }
}
