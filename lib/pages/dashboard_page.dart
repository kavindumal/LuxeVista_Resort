import 'package:flutter/material.dart';
import 'package:luxevista_resort/pages/dashboard/home_page.dart';
import 'package:luxevista_resort/pages/dashboard/profile_management_page.dart';
import 'package:luxevista_resort/pages/dashboard/room_booking_page.dart';
import 'package:luxevista_resort/pages/dashboard/service_reservation_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Dashboard extends StatefulWidget {
  static final title = 'LuxeVista Resort';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    RoomBookingPage(),
    ServiceReservationPage(),
    ProfileManagementPage(),
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
          title: Text(Dashboard.title),
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
                icon: Icon(Icons.home),
                title: Text("Home"),
                selectedColor: Colors.purple,
              ),

              /// Room Booking
              SalomonBottomBarItem(
                icon: Icon(Icons.hotel),
                title: Text("Rooms"),
                selectedColor: Colors.pink,
              ),

              /// Service Reservation
              SalomonBottomBarItem(
                icon: Icon(Icons.spa),
                title: Text("Services"),
                selectedColor: Colors.orange,
              ),

              /// Profile
              SalomonBottomBarItem(
                icon: Icon(Icons.person),
                title: Text("Profile"),
                selectedColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
