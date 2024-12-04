import 'package:flutter/material.dart';
import 'package:luxevista_resort/db/db_helper.dart';

class ServiceReservationPage extends StatefulWidget {
  const ServiceReservationPage({super.key});

  @override
  _ServiceReservationPageState createState() => _ServiceReservationPageState();
}

class _ServiceReservationPageState extends State<ServiceReservationPage> {
  final List<String> services = [
    'Spa Treatment',
    'Fine Dining',
    'Poolside Cabana',
    'Guided Beach Tour'
  ];

  String? selectedService;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool showForm = false;
  List<Map<String, dynamic>> reservations = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    final dbHelper = DatabaseHelper();
    final data = await dbHelper.getReservations();
    setState(() {
      reservations = data;
    });
  }

  Future<void> _addReservation() async {
    if (selectedService != null && selectedDate != null && selectedTime != null) {
      final dbHelper = DatabaseHelper();
      await dbHelper.addReservation(
        selectedService!,
        selectedDate!.toIso8601String(),
        selectedTime!.format(context),
      );
      await _fetchReservations();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Reserved $selectedService on ${selectedDate!.toLocal()} at ${selectedTime!.format(context)}'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a service, date, and time'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: showForm ? _buildReservationForm() : _buildReservationList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showForm = !showForm;
          });
        },
        backgroundColor: Colors.blue.shade700,
        child: Icon(showForm ? Icons.close : Icons.add, size: 28),
      ),
    );
  }

  Widget _buildReservationForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedCard(
            title: 'Select a Service',
            child: DropdownButton<String>(
              value: selectedService,
              hint: const Text('Choose a service'),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  selectedService = newValue;
                });
              },
              items: services.map((service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          _buildAnimatedCard(
            title: 'Select a Date',
            child: ElevatedButton.icon(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(selectedDate == null
                  ? 'Choose a date'
                  : '${selectedDate!.toLocal()}'.split(' ')[0]),
            ),
          ),
          const SizedBox(height: 20),
          _buildAnimatedCard(
            title: 'Select a Time',
            child: ElevatedButton.icon(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              icon: const Icon(Icons.access_time),
              label: Text(selectedTime == null
                  ? 'Choose a time'
                  : selectedTime!.format(context)),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _addReservation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Confirm Reservation',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(reservation['service']),
            subtitle: Text(
              'Date: ${DateTime.parse(reservation['date']).toLocal()}'
              '\nTime: ${reservation['time']}',
            ),
            leading: Icon(Icons.event, color: Colors.blue.shade700),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
