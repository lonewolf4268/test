import 'package:flutter/material.dart';

import '../DashboardScreen/dashboard_screen.dart';

class ShopNowScreen extends StatefulWidget {
  const ShopNowScreen({Key? key}) : super(key: key);

  @override
  _ShopNowScreenState createState() => _ShopNowScreenState();
}

class _ShopNowScreenState extends State<ShopNowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigate back to the DashboardScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Shop Now'),
      ),
      body: SingleChildScrollView( // Wrap your content in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar (replace with your actual implementation)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for products',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Categories Section
              Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Horizontal Scrollable Categories (replace with your actual data)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Replace with actual number of categories
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8ZmFzaGlvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'), // Placeholder image
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Category ${index + 1}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Featured Products Section
              Text(
                'Featured Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Grid of Featured Products (replace with your actual data)
              GridView.builder(
                shrinkWrap: true, // Important for a scrollable list
                physics: NeverScrollableScrollPhysics(), // Disable scroll within GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 8, // Replace with actual number of products
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage('https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8ZmFzaGlvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'), // Placeholder image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Name ${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '\$19.99',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        currentIndex: 1, // Set the initial selected item
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
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ShopNowScreen()),
              );
              break;
          // Add navigation for Notifications and Profile if needed
          }
        },
      ),
    );
  }
}
