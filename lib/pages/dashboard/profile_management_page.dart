import 'package:flutter/material.dart';

class ProfileManagementPage extends StatelessWidget {
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
                _buildProfileDetail('Name', 'John Doe'),
                _buildProfileDetail('Email', 'john.doe@example.com'),
                _buildProfileDetail('Phone Number', '+1234567890'),
              ]),
              SizedBox(height: 20),
              _buildSectionTitle('Preferences'),
              _buildProfileCard([
                _buildProfileDetail('Room Type', 'Deluxe'),
                _buildProfileDetail('Interests', 'Spa, Fine Dining'),
              ]),
              SizedBox(height: 20),
              _buildSectionTitle('Booking History'),
              _buildBookingHistory(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add edit profile functionality
        },
        label: Text('Edit Profile'),
        icon: Icon(Icons.edit),
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
      margin: EdgeInsets.symmetric(vertical: 10),
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
              style: TextStyle(
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
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(Icons.hotel, color: Colors.blue.shade700),
            title: Text(
              'Booking #${index + 1}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Room - Deluxe\nDate: 2023-10-01',
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
