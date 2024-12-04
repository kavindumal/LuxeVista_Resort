import 'package:flutter/material.dart';
import 'package:luxevista_resort/pages/dashboard/home_page.dart';
import 'package:luxevista_resort/pages/dashboard/profile_management_page.dart';
import 'package:luxevista_resort/pages/dashboard/room_booking_page.dart';
import 'package:luxevista_resort/pages/dashboard/service_reservation_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Dashboard extends StatefulWidget {
  static const title = 'LuxeVista Resort';

  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const RoomBookingPage(),
    const ServiceReservationPage(),
    const ProfileManagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Dashboard.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(Dashboard.title),
          backgroundColor: Colors.blue.shade700,
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade300, Colors.blue.shade700],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: const Icon(Icons.home),
                title: const Text("Home"),
                selectedColor: Colors.purple,
              ),

              /// Room Booking
              SalomonBottomBarItem(
                icon: const Icon(Icons.hotel),
                title: const Text("Rooms"),
                selectedColor: Colors.pink,
              ),

              /// Service Reservation
              SalomonBottomBarItem(
                icon: const Icon(Icons.spa),
                title: const Text("Services"),
                selectedColor: Colors.orange,
              ),

              /// Profile
              SalomonBottomBarItem(
                icon: const Icon(Icons.person),
                title: const Text("Profile"),
                selectedColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
