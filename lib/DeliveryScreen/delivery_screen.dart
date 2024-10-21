import 'package:flutter/material.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Pickup & Deliveries'),
      ),
      body: SingleChildScrollView( // Make the body scrollable
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select your delivery type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Delivery Option Cards
              _buildDeliveryOptionCard(
                title: 'Instant delivery',
                description: 'Get your packages delivered on the same day, swiftly and reliably.',
                icon: Icons.download_rounded,
                backgroundColor: Colors.purple.shade100,
                iconColor: Colors.purple,
              ),
              SizedBox(height: 15),
              _buildDeliveryOptionCard(
                title: 'Scheduled delivery',
                description: 'Your packages arrive exactly when you need them.',
                icon: Icons.access_time_rounded,
                backgroundColor: Colors.yellow.shade100,
                iconColor: Colors.yellow,
              ),
              SizedBox(height: 15),
              _buildDeliveryOptionCard(
                title: 'Express or Night delivery',
                description: 'Experience fast, overnight delivery to get your packages by the next day.',
                icon: Icons.brightness_2_rounded,
                backgroundColor: Colors.blue.shade100,
                iconColor: Colors.blue,
              ),
              SizedBox(height: 15),
              _buildDeliveryOptionCard(
                title: 'Multiple Collection',
                description: 'Arrange multiple pickups and delivery in one go for added convenience.',
                icon: Icons.check_circle_rounded,
                backgroundColor: Colors.orange.shade100,
                iconColor: Colors.orange,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
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
        onTap: (index) {
          // Handle navigation to different screens based on the selected index
          print('Bottom Navigation Bar Item $index tapped.');
        },
      ),
    );
  }

  Widget _buildDeliveryOptionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
