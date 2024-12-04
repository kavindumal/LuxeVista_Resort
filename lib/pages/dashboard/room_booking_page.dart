import 'package:flutter/material.dart';

class RoomBookingPage extends StatefulWidget {
  const RoomBookingPage({super.key});

  @override
  _RoomBookingPageState createState() => _RoomBookingPageState();
}

class _RoomBookingPageState extends State<RoomBookingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  String? selectedRoomType;
  String? selectedPriceRange;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRoomCard(String title, String description, String price,
      String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.darken),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Column(
          children: [
            // Filter Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedRoomType,
                    hint: const Text("Room Type"),
                    items: ["Ocean View", "Deluxe", "Standard"]
                        .map((String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoomType = value;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedPriceRange,
                    hint: const Text("Price Range"),
                    items: ["\$100-\$200", "\$200-\$300", "\$300+"]
                        .map((String range) {
                      return DropdownMenuItem(
                        value: range,
                        child: Text(range),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPriceRange = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Room Cards
            Expanded(
              child: ListView(
                children: [
                  _buildRoomCard(
                    "Ocean View Suite",
                    "Enjoy a breathtaking ocean view with luxurious amenities.",
                    "\$250/night",
                    "assets/images/ocean_view.jpg",
                    () {
                      // Navigate to booking page
                      print("Ocean View Suite tapped");
                    },
                  ),
                  _buildRoomCard(
                    "Deluxe Room",
                    "Spacious deluxe room with a cozy ambiance.",
                    "\$200/night",
                    "assets/images/deluxe_room.jpg",
                    () {
                      // Navigate to booking page
                      print("Deluxe Room tapped");
                    },
                  ),
                  _buildRoomCard(
                    "Standard Room",
                    "A comfortable standard room for your stay.",
                    "\$150/night",
                    "assets/images/standard_room.jpg",
                    () {
                      // Navigate to booking page
                      print("Standard Room tapped");
                    },
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
