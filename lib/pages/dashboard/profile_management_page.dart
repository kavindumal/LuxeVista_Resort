import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luxevista_resort/db/db_helper.dart';

class ProfileManagementPage extends StatefulWidget {
  const ProfileManagementPage({super.key});

  @override
  _ProfileManagementPageState createState() => _ProfileManagementPageState();
}

class _ProfileManagementPageState extends State<ProfileManagementPage> {
  Map<String, dynamic>? userDetails;
  List<Map<String, dynamic>> bookingHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchBookingHistory();
  }

  Future<void> _fetchUserData() async {
    final dbHelper = DatabaseHelper();
    final userEmail = await dbHelper.getUserDetails();

    if (userEmail != null) {
      final user = await dbHelper.getUserByEmail(userEmail);
      setState(() {
        userDetails = user;
      });
    } else {
    }
  }

  Future<void> _fetchBookingHistory() async {
    final dbHelper = DatabaseHelper();
    final bookings = await dbHelper.getBookings();
    setState(() {
      bookingHistory = bookings.where((booking) => booking['user_id'] == userDetails?['user_id']).toList();
    });
  }

  Future<void> _showEditProfileDialog() async {
    final nameController = TextEditingController(text: userDetails?['name']);
    final emailController = TextEditingController(text: userDetails?['email']);
    final phoneController = TextEditingController(text: userDetails?['phone_number']);
    final passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final dbHelper = DatabaseHelper();
                final updatedData = {
                  'name': nameController.text,
                  'email': emailController.text,
                  'phone_number': phoneController.text,
                };

                if (passwordController.text.isNotEmpty) {
                  updatedData['password'] = passwordController.text;
                }

                await dbHelper.updateUser(userDetails?['user_id'], updatedData);

                await _fetchUserData();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('User Details'),
              _buildProfileCard([
                _buildProfileDetail('Name', userDetails?['name'] ?? 'Loading...'),
                _buildProfileDetail('Email', userDetails?['email'] ?? 'Loading...'),
                _buildProfileDetail('Phone Number', userDetails?['phone_number'] ?? 'Loading...'),
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle('Preferences'),
              _buildProfileCard([
                _buildProfileDetail('Room Type', 'Deluxe'),
                _buildProfileDetail('Interests', 'Spa, Fine Dining'),
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle('Booking History'),
              _buildBookingHistory(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showEditProfileDialog,
        label: const Text('Edit Profile'),
        icon: const Icon(Icons.edit),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.blue.shade700,
      ),
    );
  }

  Widget _buildProfileCard(List<Widget> details) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: details,
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$title:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              detail,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingHistory() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: bookingHistory.length,
        itemBuilder: (context, index) {
          final booking = bookingHistory[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(Icons.hotel, color: Colors.blue.shade700),
            title: Text(
              'Booking #${booking['booking_id']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Room - ${booking['room_id']}\nDate: ${booking['check_in_date']}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
            onTap: () {
              // Handle navigation to booking details
            },
          );
        },
      ),
    );
  }
}