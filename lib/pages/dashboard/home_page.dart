import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State to manage expanded/collapsed card states
  final Map<String, bool> _expanded = {
    "Room Booking": false,
    "Services": false,
    "Nearby Attractions": false,
  };

  void _toggleExpand(String cardTitle) {
    setState(() {
      _expanded[cardTitle] = !_expanded[cardTitle]!;
    });
  }

  void _showPopupMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Feature Unavailable"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Image
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/resort.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Text(
                    "Welcome to LuxeVista Resort",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Welcome Text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Experience unparalleled luxury and personalized services at LuxeVista Resort. Explore our premium accommodations and exclusive offers to make your stay unforgettable.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ),

            // Feature Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildFeatureCard(
                    context,
                    "Room Booking",
                    "Explore and book luxurious rooms with stunning views.",
                    Icons.hotel,
                    () => _showPopupMessage(
                      "This feature is not available yet. Sorry for the inconvenience.",
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    "Services",
                    "Reserve spa treatments, cabanas, and fine dining.",
                    Icons.spa,
                    () => _showPopupMessage(
                      "This feature is not available yet. Sorry for the inconvenience.",
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    "Nearby Attractions",
                    "Discover exciting activities and attractions nearby.",
                    Icons.place,
                    () => _showPopupMessage(
                      "This feature is not available yet. Sorry for the inconvenience.",
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Enjoy Your Stay at LuxeVista Resort",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String subtitle,
  IconData icon, VoidCallback onTap) {
  final isExpanded = _expanded[title] ?? false;
  return GestureDetector(
  onTap: () => _toggleExpand(title),
  child: Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Row(
        children: [
        Icon(
          icon,
          size: 40,
          color: Colors.blue.shade700,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
          ),
        ),
        Icon(
          isExpanded
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down,
          size: 24,
          color: Colors.grey.shade700,
        ),
        ],
      ),
      if (isExpanded) ...[
        const SizedBox(height: 8),
        Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.blue.shade700,
          padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
          ),
        ),
        child: const Text(
          "Learn More",
          style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          ),
        ),
        ),
      ],
      ],
    ),
    ),
  ),
  );
}
}
