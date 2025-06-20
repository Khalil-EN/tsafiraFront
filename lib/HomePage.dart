import 'dart:ui';
import 'package:flutter/material.dart';
import 'profile_menu.dart';
import 'profile.dart';
import 'discover.dart';
import 'plan_trip0.dart';
import 'Community.dart';  // This should import your actual FlightIntroScreen file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: TravelHomePage(),
    );
  }
}

class TravelHomePage extends StatefulWidget {
  @override
  _TravelHomePageState createState() => _TravelHomePageState();
}

class _TravelHomePageState extends State<TravelHomePage> {
  // Control whether the profile menu is shown
  bool _showProfileMenu = false;
  // Reference to the HomeNavState for controlling the navigation
  final GlobalKey<HomeNavState> _navKey = GlobalKey<HomeNavState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section with Mountain Image - circular edges while sticking to screen sides
                  Container(
                    margin: EdgeInsets.zero, // Removed margin to stick to screen edges
                    height: 380,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: Stack(
                        children: [
                          // Mountain Image
                          Image.asset(
                            'assets/montain.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          // Top Menu (profile on left and search on right)
                          Positioned(
                            top: 16,
                            left: 16,
                            right: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Profile icon on the left
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showProfileMenu = !_showProfileMenu;
                                    });
                                  },
                                  child: Icon(Icons.person_outline, color: Colors.white, size: 28),
                                ),
                                // Search icon on the right
                                Icon(Icons.search, color: Colors.white, size: 28),
                              ],
                            ),
                          ),
                          // Explore text content
                          Positioned(
                            top: 70,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'EXPLORE\nTHE BEAUTY\nOF MOROCCO\nAROUND YOU',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Connected action bar at the bottom with two buttons
                          Positioned(
                            bottom: 20,
                            left: 16,
                            right: 16,
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    'EXPLORE',
                                    'assets/explore.png',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => DiscoverScreen()),
                                      );
                                      // Navigate to explore and update nav bar
                                      _navKey.currentState?.changeIndex(2);
                                    },
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  _buildActionButton(
                                    'PLAN TRIP',
                                    'assets/location.png',
                                    onTap: () {
                                      // Navigate to FlightIntroScreen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const FlightIntroScreen()),
                                      );
                                      // Update nav bar
                                      _navKey.currentState?.changeIndex(3);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Discover Section
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discover',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 40),
                        
                        // Destination Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildDiscoverCard(
                                'Parki El Hamadi',
                                'Tetouan',
                                'assets/parki.jpg',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildDiscoverCard(
                                'Jamaa El Fna',
                                'Marrakech',
                                'assets/jama3.jpg',
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 40),
                        
                        // Most Popular Section
                        Text(
                          'Most Popular',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Popular destination card
                        Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: AssetImage('assets/esaouira.jpg'), // Replace with your image
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.purple.shade100.withOpacity(0.7), 
                                    BlendMode.srcATop
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Location details
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Essaouira',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, color: Colors.white, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            'Morocco',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(), // Pushes the rating to the right
                                  // Rating container
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.shade400,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.white, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          '4.8',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Profile Menu Overlay - only shown when _showProfileMenu is true
          if (_showProfileMenu)
            ProfileMenu(
              onClose: () {
                setState(() {
                  _showProfileMenu = false;
                });
              },
            ),
        ],
      ),
      // Use the new HomeNav widget and provide the key for access
      bottomNavigationBar: HomeNav(key: _navKey),
      // Removed the duplicate floating action button and its location
    );
  }
  
  Widget _buildActionButton(String title, String iconPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 28,
            height: 28,
            color: Colors.white,
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDiscoverCard(String title, String? location, String imagePath) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (location != null)
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 12,
                  ),
                  SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// Updated HomeNav widget as a StatefulWidget
class HomeNav extends StatefulWidget {
  const HomeNav({Key? key}) : super(key: key);
  
  @override
  State<HomeNav> createState() => HomeNavState();
}

class HomeNavState extends State<HomeNav> {
  int _selectedIndex = 0;
  
  // Method to change the selected index that can be called from parent
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
        // Bottom navigation bar
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
              // Empty space for the center button
              Container(width: 60),
              _buildNavItem(3, 'assets/community.png'),
              _buildNavItem(4, 'assets/user.png'),
            ],
          ),
        ),
        
        // Center floating button positioned on top
        Positioned(
          bottom: 5, // Adjust this value to position the button vertically
          child: MainNavButton(
            onTap: () {
              // Navigate to the FlightIntroScreen when center button is tapped
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
        
        // If the explore icon (index 1) is tapped, navigate to DiscoverScreen
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiscoverScreen()),
          );
        }
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  CommunityScreen()),
          );
        }
        
        // If the flights icon (index 3) is tapped, navigate to FlightIntroScreen
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  CommunityScreen()),
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
          size: 36, // Reduced size for better fit
        ),
      ),
    );
  }
}

// The main floating action button separated into its own widget
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
            width: 60, // Full width of the container
            height: 60, // Full height of the container
            fit: BoxFit.contain, // Preserve aspect ratio but fit within dimensions
          ),
        ),
      ),
    );
  }
}
