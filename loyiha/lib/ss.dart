import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  DateTime _deadline = DateTime(2024, 12, 31, 23, 59, 59); // Set your target deadline
  DateTime _now = DateTime.now();
  late String _days;
  late String _hours;
  late String _minutes;
  late String _seconds;
  late Timer _timer; // Define the timer

  @override
  void initState() {
    super.initState();
    _days = "";
    _hours = "";
    _minutes = "";
    _seconds = "";
    _updateTime(); // Initial call to set the time
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      Duration difference = _deadline.difference(_now);

      if (difference.isNegative) {
        _days = "";
        _hours = "";
        _minutes = "";
        _seconds = "";
      } else {
        int days = difference.inDays;
        int hours = difference.inHours % 24;
        int minutes = difference.inMinutes % 60;
        int seconds = difference.inSeconds % 60;

        _days = "${days}d";
        _hours = "${hours}h";
        _minutes = "${minutes}m";
        _seconds = "${seconds}s";
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Dispose of the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Yil tugashiga qolgan vaqt',
            
            ),
            SizedBox(height: 20), // Add some space between the text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeBox('Kuni', _days),
                _buildTimeBox('Soat', _hours),
                _buildTimeBox('Daqiqa', _minutes),
                _buildTimeBox('Sekund', _seconds),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(String label, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
       
        ),
        Text(
          label,
       
        ),
      ],
    );
  }
}
