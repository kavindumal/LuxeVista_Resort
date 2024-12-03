import 'package:flutter/material.dart';
import 'package:luxevista_resort/pages/dashboard_page.dart';

class NearbyAttractionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Attractions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    'assets/images/nearby_attractions_header.png', // Replace with a suitable image in your assets folder
                    height: 150,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Nearby Attractions',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.beach_access, color: Colors.white),
                      title: Text(
                        "Sunny Beach",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Enjoy the sun and the sea at Sunny Beach.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.park, color: Colors.white),
                      title: Text(
                        "Green Park",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Relax and unwind at Green Park.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.museum, color: Colors.white),
                      title: Text(
                        "City Museum",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Explore the history and culture at City Museum.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_bag, color: Colors.white),
                      title: Text(
                        "Shopping Mall",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Shop till you drop at the nearby mall.",
                        style: TextStyle(color: Colors.white70),
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
}