import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'discover.dart';
import 'plan_trip0.dart';
import 'profile.dart';
import 'profile_menu.dart';

void main() {   
  runApp(const CommunityScreen()); 
}  

class CommunityScreen extends StatelessWidget {   
  const CommunityScreen({super.key});    

  @override   
  Widget build(BuildContext context) {     
    return MaterialApp(       
      title: 'Travel App Mockup',       
      theme: ThemeData(         
        primarySwatch: Colors.blue,         
        fontFamily: 'Roboto',         
        scaffoldBackgroundColor: Colors.white,       
      ),       
      home: const HomeScreen(),     
    );   
  } 
}  

class HomeScreen extends StatefulWidget {   
  const HomeScreen({super.key});    

  @override   
  _HomeScreenState createState() => _HomeScreenState(); 
}  

class _HomeScreenState extends State<HomeScreen> {   
  bool _showProfileMenu = false;    

  @override   
  Widget build(BuildContext context) {     
    return Scaffold(       
      body: SafeArea(         
        child: Stack(           
          children: [             
            Column(               
              crossAxisAlignment: CrossAxisAlignment.start,               
              children: [                 
                Padding(                   
                  padding: const EdgeInsets.all(16.0),                   
                  child: Row(                     
                    mainAxisAlignment: MainAxisAlignment.start,                     
                    children: [                       
                      GestureDetector(                         
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ProfileMenu(
                              onClose: () {
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.person_outline, 
                          color: Color.fromARGB(255, 141, 131, 131), 
                          size: 28
                        ), ),  
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Friends Visited',
                                style: TextStyle(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xFF18335A)
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: index == 0 
                                  ? const EdgeInsets.only(left: 16.0, right: 16.0)
                                  : const EdgeInsets.only(right: 16.0),
                                child: _buildFriendsVisitedCard(index),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Explore Cities',
                                style: TextStyle(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xFF18335A)
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: index == 0 
                                  ? const EdgeInsets.only(left: 16.0, right: 16.0)
                                  : const EdgeInsets.only(right: 16.0),
                                child: _buildExploreCitiesCard(index),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'World Most Booked',
                                style: TextStyle(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xFF18335A)
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: index == 0 
                                  ? const EdgeInsets.only(left: 16.0, right: 16.0)
                                  : const EdgeInsets.only(right: 16.0),
                                child: _buildWorldMostBookedCard(index),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Profile Menu Overlay
            if (_showProfileMenu)
              Positioned(
                top: 60,
                right: 16,
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Profile'),
                        onTap: () {
                          setState(() {
                            _showProfileMenu = false;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                        onTap: () {
                          setState(() {
                            _showProfileMenu = false;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: () {
                          setState(() {
                            _showProfileMenu = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: HomeNav(),
    );
  }

  Widget _buildFriendsVisitedCard(int index) {
    String title = index == 0 ? 'Sunset Lodge' : 'The New View';
    String moreText = index == 0 ? '+2 More' : '+4 More';
    
    return Container(
      width: 230,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                Image.asset(
                  index == 0 ? 'assets/tetouan1.jpg' : 'assets/tetouan2.jpg',
                  height: 160,
                  width: 230,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text('4.8', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: AssetImage('assets/face1.png'),
                    ),
                    const SizedBox(width: 4),
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: AssetImage('assets/face2.png'),
                    ),
                    const SizedBox(width: 4),
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: AssetImage('assets/face3.png'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      moreText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCitiesCard(int index) {
    List<String> cityNames = ['Rabat, Morocco', 'Tanger, Morocco'];
    
    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              index == 0 ? 'assets/tanger.jpg' : 'assets/rabat.jpg',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Text(
              cityNames[index],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF8CE7C9),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'EXPLORE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorldMostBookedCard(int index) {
    List<String> locations = ['Paros, Greece', 'Budapest, Hungary'];
    List<String> prices = ['\$500/Day', '\$350/Day'];
    
    return Container(
      width: 280,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                Image.asset(
                  index == 0 ? 'assets/paros.png' : 'assets/paros2.png',
                  height: 160,
                  width: 280,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text('4.2', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locations[index],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: AssetImage('assets/face1.png'),
                    ),
                    const SizedBox(width: 4),
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: AssetImage('assets/face2.png'),
                    ),
                    const SizedBox(width: 4),
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: AssetImage('assets/face3.png'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+2 More',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      prices[index],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8CE7C9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeNav extends StatefulWidget {   
  @override   
  HomeNavState createState() => HomeNavState(); 
}  

class HomeNavState extends State {   
  int _selectedIndex = 3;  // Set to 3 to highlight community icon    

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
                MaterialPageRoute(builder: (context) => FlightIntroScreen()),               
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
        if (index == 3) {           
          Navigator.push(             
            context,             
            MaterialPageRoute(builder: (context) => CommunityScreen()),           
          );         
        }         
        if (index == 4) {           
          Navigator.push(             
            context,             
            MaterialPageRoute(builder: (context) => ProfileScreen()),           
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
