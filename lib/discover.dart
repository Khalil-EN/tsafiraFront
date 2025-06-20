import 'package:flutter/material.dart';
import 'hotel_list.dart';
import 'Community.dart';
import 'HomePage.dart';
import 'profile.dart';
import 'plan_trip0.dart';
import 'restaurant_list.dart';
import 'activities_list.dart';

class DiscoverScreen extends StatelessWidget {
  final List<DiscoverItem> discoveryItems = [
    DiscoverItem(
      title: 'HOTEL',
      iconPath: 'assets/hotel_logo.png',
      colors: [Color(0xFF71BBFF), Color(0xFFDB76FF)],
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HotelsPage()),
        );
      },
    ),
    DiscoverItem(
      title: 'RESTAURANT',
      iconPath: 'assets/restaurant_logo.png',
      colors: [Color(0xFF56E79F), Color(0xFF4093E7)],
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RestaurantsPage()),
        );
      },
    ),
    DiscoverItem(
      title: 'Activities',
      iconPath: 'assets/Advanture.png',
      colors: [Color.fromARGB(223, 253, 5, 211), Color(0xFFAC56EA)],
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActivitiesPage()),
        );
      },
    ),
    DiscoverItem(
      title: 'FLIGHTS',
      iconPath: 'assets/flight_logo.png',
      colors: [Color.fromARGB(255, 230, 251, 0), Color.fromARGB(255, 4, 199, 11)],
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HotelsPage()),
        );
      },
    ),
    DiscoverItem(
      title: 'EVENTS',
      iconPath: 'assets/Events.png',
      colors: [Color.fromARGB(255, 229, 134, 1), Color.fromARGB(255, 240, 21, 5).withOpacity(0.5)],
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HotelsPage()),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // New header with back button and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: discoveryItems.length,
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildDiscoverItem(context, discoveryItems[index]);
                },
              ),
            ),
            HomeNav(), // Existing navigation bar
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverItem(BuildContext context, DiscoverItem item) {
    return GestureDetector(
      onTap: () => item.onTap(context),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: item.colors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          image: DecorationImage(
            image: AssetImage('assets/back2.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.03),
              BlendMode.dstATop,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              spreadRadius: 10,
              blurRadius: 100,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              item.iconPath,
              width: 80,
              height: 80,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              item.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscoverItem {
  final String title;
  final String iconPath;
  final List<Color> colors;
  final Function(BuildContext context) onTap;

  DiscoverItem({
    required this.title,
    required this.iconPath,
    required this.colors,
    required this.onTap,
  });
}

class HomeNav extends StatefulWidget {
  const HomeNav({Key? key}) : super(key: key);

  @override
  State<HomeNav> createState() => HomeNavState();
}

class HomeNavState extends State<HomeNav> {
  int _selectedIndex = 1;

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
              ),
            ],
          ),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'assets/home.png'),
              _buildNavItem(1, 'assets/discover.png'),
              Container(width: 60),
              _buildNavItem(3, 'assets/community.png'),
              _buildNavItem(4, 'assets/user.png'),
            ],
          ),
        ),
        Positioned(
          bottom: 5,
          child: MainNavButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FlightIntroScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(int index, String iconPath) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });

        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        }
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiscoverScreen()),
          );
        }
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommunityScreen()),
          );
        }

        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommunityScreen()),
          );
        }
        if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ImageIcon(
          AssetImage(iconPath),
          color: isSelected ? Colors.blue : Colors.grey,
          size: 36,
        ),
      ),
    );
  }
}

class MainNavButton extends StatelessWidget {
  final VoidCallback onTap;

  const MainNavButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.cyan,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/icon_nav.png',
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
