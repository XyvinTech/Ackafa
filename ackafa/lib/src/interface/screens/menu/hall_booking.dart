import 'dart:developer';

import 'package:ackaf/src/data/models/hall_models.dart';
import 'package:ackaf/src/data/services/api_routes/hall_api.dart';
import 'package:ackaf/src/interface/common/customTextfields.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/custom_calender_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HallBookingPage extends StatefulWidget {
  const HallBookingPage({Key? key}) : super(key: key);

  @override
  State<HallBookingPage> createState() => _HallBookingPageState();
}

class _HallBookingPageState extends State<HallBookingPage> {
  String? selectedHall;
  String? selectedHallAddress;
  String? v;
  DateTime selectedDate = DateTime.now();
  String bookingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 30);
  TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 30);
  TextEditingController eventNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool proceed = false;
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print("Selected Day: $selectedDay");

    print("Selected date: $bookingDate");
  }

  List<Hall> halls = [
    Hall(
        name: 'SP Yogam Centenary Hall',
        address:
            'SP Yogam Centenary Hall\nX8F8+F6G, Mahakavi Vailoppilli Rd, Ponnurunni, Vyttila, Kochi, Ernakulam, Kerala 682019'),
    Hall(
        name: 'Main Auditorium',
        address:
            'SP Yogam Centenary Hall\nX8F8+F6G, Mahakavi Vailoppilli Rd, Ponnurunni, Vyttila, Kochi, Ernakulam, Kerala 682019')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Hall Booking',
          style: TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: .5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Choose Hall *", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedHall,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white, // Sets the background color to white
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 231, 221,
                        221), // Sets the border color to grey for the default state
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 231, 221,
                        221), // Sets the border color to grey for the focused state
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              hint: const Text("Select Hall"),
              items: halls
                  .map((hall) => DropdownMenuItem<String>(
                        value: hall.name,
                        child: Text(hall.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedHall = value;
                  proceed = false;
                  // Update the address variable
                  selectedHallAddress =
                      halls.firstWhere((hall) => hall.name == value).address;

                  // Debug or use the address variable
                  print('Selected Hall Address: $selectedHallAddress');
                });
              },
            ),
            const SizedBox(height: 16),
            customButton(
              label: 'PROCEED',
              onPressed: () {
                setState(() {
                  proceed = true;
                });
              },
            ),
            if (proceed)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    selectedHall ?? '',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    selectedHallAddress ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Text("Booking Date",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  CustomCalendar(
                    onDaySelected: _onDaySelected,
                  ),
                  const SizedBox(height: 16),
                  const Text("Booked Events",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  _eventCard("Event Name", "09:30 AM - 05:30 PM"),
                  _eventCard("Event Name 2", "07:30 AM - 08:30 PM"),
                  const SizedBox(height: 16),
                  const Text("Booking Time",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: _timePicker("Start Time", startTime, (time) {
                          setState(() {
                            startTime = time;
                            log(time.toString());
                          });
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.grey),
                          width: .8,
                          height: 65,
                        ),
                      ),
                      Expanded(
                        child: _timePicker("End Time", endTime, (time) {
                          setState(() {
                            endTime = time;
                            log(time.toString());
                          });
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please select a time slot that does not overlap with any events listed above.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Text("Event Details", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                      fillColor: Colors.white,
                      labelText: 'Event Name',
                      textController: eventNameController),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    fillColor: Colors.white,
                    labelText: 'Description',
                    textController: descriptionController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            if (proceed)
              customButton(
                  label: 'CONFIRM',
                  onPressed: () {
                    Map<String, dynamic> bookingData = {
                      "day": daysOfWeek[selectedDate.weekday - 1],
                      "time": {
                        "start": "${startTime.hour}:${startTime.minute}",
                        "end": "${endTime.hour}:${endTime.minute}",
                      },
                      "hall": selectedHall,
                      "date": selectedDate,
                      "eventName": eventNameController.text,
                      "description": descriptionController.text
                    };
                    bookHall(bookingData);
                  })
          ],
        ),
      ),
    );
  }

  Widget _eventCard(String name, String time) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFEAEA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.calendar_today, color: Colors.red),
            )),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time),
      ),
    );
  }

  Widget _timePicker(
      String label, TimeOfDay time, Function(TimeOfDay) onTimeSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8, right: 8.0),
          child: Text(
            'Start time',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () async {
            TimeOfDay? pickedTime =
                await showTimePicker(context: context, initialTime: time);
            if (pickedTime != null) onTimeSelected(pickedTime);
          },
          child: SizedBox(
            width: double.infinity, // Set a fixed width
            height: 40, // Set a fixed height
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 3,
                    color: Colors.grey,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8, // Adjust padding to fit smaller size
                  vertical: 4,
                ),
              ),
              child: Center(
                child: Text(
                  time.format(context),
                  style: const TextStyle(
                    fontSize: 14, // Optional: Adjust font size
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
