import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: showForm
            ? _buildReservationForm()
            : _buildReserveNowPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showForm = !showForm;
          });
        },
        backgroundColor: Colors.blue.shade700,
        child: Icon(showForm ? Icons.close : Icons.edit, size: 28),
      ),
    );
  }

  Widget _buildReserveNowPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 100, color: Colors.blue.shade700),
          const SizedBox(height: 20),
          Text(
            'Reserve a Service',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap the button below to get started.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
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
              onPressed: () {
                if (selectedService != null &&
                    selectedDate != null &&
                    selectedTime != null) {
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
              },
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
