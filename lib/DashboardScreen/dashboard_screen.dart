import 'package:deswift/DeliveryScreen/delivery_screen.dart';
import 'package:deswift/LoginScreen/login_screen.dart';
import 'package:deswift/ShopNowScreen/shop_now_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _token;
  bool _isVerified = false;
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      _isVerified = prefs.getBool('is_verified') ?? false;
    });
    _checkAuthentication();
  }

  void _checkAuthentication() {
    if (_token == null || _token!.isEmpty || !_isVerified) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      final url = 'http://app.de-swift.com/account/customer/logout/';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log out. Please try again.')),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }


  Future<bool> _onWillPop() async {
    if (_lastBackPressed == null ||
        DateTime.now().difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Press back twice to exit')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Dashboard'),
          actions: [
            IconButton(
              onPressed: _logout,
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView( // Wrap your content in SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User profile section (replace with your actual profile info)
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377040?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'), // Placeholder image
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'I am Okay',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Spacer()
                  ],
                ),
                SizedBox(height: 20),

                Text(
                  'What would you like to do?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Shop Now section
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopNowScreen(), // Navigate to ShopNowScreen
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(Icons.shopping_bag, size: 40, color: Colors.purple),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shop Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Explore Products And Shop With Ease.',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.purple.shade100),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Pickup and Deliveries section
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryScreen(), // Navigate to DeliveryScreen
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(Icons.delivery_dining, size: 40, color: Colors.green),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pickup and Deliveries',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Have your packages picked up and delivered at your convenience.',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.delivery_dining_outlined, size: 50, color: Colors.green.shade100),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // History Section
                Text(
                  'History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // History Items (replace with your actual data)
                Column(
                  children: [
                    _buildHistoryItem(
                      orderId: 'ORDB1234',
                      recipient: 'Alice Mcburnie',
                      status: 'Completed',
                      details: 'Pickup & Delivery\nLapaz - Tema\n12 July 2024, 2:43pm',
                    ),
                    SizedBox(height: 10),
                    _buildHistoryItem(
                      orderId: 'ORDB1234',
                      recipient: 'Alice Mcburnie',
                      status: 'Completed',
                      details: 'Pickup & Delivery\nLapaz - Tema\n12 July 2024, 2:43pm',
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // See All Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {}, // Implement "See All" functionality
                    child: Text('See All', style: TextStyle(color: Colors.purple)),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.black,
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHistoryItem({
  required String orderId,
  required String recipient,
  required String status,
  required String details,
}) {
  return Card(
    elevation: 2,
    child: Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            orderId,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text('Recipient: $recipient'),
          SizedBox(height: 5),
          Text(details),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {}, // Implement action for completed status
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(color: Colors.white),
              ),
              child: Text(status),
            ),
          ),
        ],
      ),
    ),
  );
}

