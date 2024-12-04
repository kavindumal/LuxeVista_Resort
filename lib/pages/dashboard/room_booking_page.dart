import 'package:flutter/material.dart';
import 'package:luxevista_resort/db/db_helper.dart';

class RoomBookingPage extends StatefulWidget {
  const RoomBookingPage({super.key});

  @override
  RoomBookingPageState createState() => RoomBookingPageState();
}

class RoomBookingPageState extends State<RoomBookingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  String? selectedRoomType;
  String? selectedPriceRange;
  final List<Map<String, String>> bookedRooms = [];

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

  void _bookRoom(String title, String description, String price) async {
    final dbHelper = DatabaseHelper();
    
    const userId = 1;

    final rooms = await dbHelper.getRooms();
    final room = rooms.firstWhere(
      (r) => r['description'] == description && r['room_type'] == title,
      orElse: () => {},
    );

    if (room == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book $title. Room not found in database.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final roomId = room['room_id'];

    final booking = {
      "user_id": userId,
      "room_id": roomId,
      "check_in_date": DateTime.now().toIso8601String(),
      "check_out_date": DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      "status": "Booked",
    };

    final result = await dbHelper.saveBooking(booking);

    if (result > 0) {
      setState(() {
        bookedRooms.add({
          "title": title,
          "description": description,
          "price": price,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title has been booked successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book $title.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildRoomCard(String title, String description, String price,
      String imagePath, VoidCallback onTap) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
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
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () => _bookRoom(title, description, price),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Book"),
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

  Widget _buildBookedRoomCard(Map<String, String> room) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.hotel, color: Colors.blue),
        title: Text(room['title']!),
        subtitle: Text(room['description']!),
        trailing: Text(
          room['price']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildRoomCard(
                    "Ocean View Suite",
                    "Enjoy a breathtaking ocean view with luxurious amenities.",
                    "\$250/night",
                    "assets/images/ocean_view.jpg",
                    () {},
                  ),
                  _buildRoomCard(
                    "Deluxe Room",
                    "Spacious deluxe room with a cozy ambiance.",
                    "\$200/night",
                    "assets/images/deluxe_room.jpg",
                    () {},
                  ),
                  _buildRoomCard(
                    "Standard Room",
                    "A comfortable standard room for your stay.",
                    "\$150/night",
                    "assets/images/standard_room.jpg",
                    () {},
                  ),
                ],
              ),

              // Booked Rooms Section
              if (bookedRooms.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Your Booked Rooms",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookedRooms.length,
                  itemBuilder: (context, index) {
                    return _buildBookedRoomCard(bookedRooms[index]);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
