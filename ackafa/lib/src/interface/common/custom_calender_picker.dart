import 'package:ackaf/src/data/models/hall_models.dart';
import 'package:ackaf/src/data/services/api_routes/hall_api.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime selectedDay, DateTime focusedDay)? onDaySelected;
  final List<AvailableTimeModel>? hallTimes;

  const CustomCalendar({
    super.key,
    this.onDaySelected,
    this.hallTimes,
  });

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  final List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<DateTime> _unselectableDays = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  bool _isDaySelectable(DateTime day) {
    if (_unselectableDays
        .any((unselectableDay) => isSameDay(unselectableDay, day))) {
      return false;
    }

    String dayName = _daysOfWeek[day.weekday - 1].toLowerCase();

    if (widget.hallTimes == null || widget.hallTimes!.isEmpty) {
      return true;
    }

    bool isDayAvailable =
        widget.hallTimes!.any((time) => time.day!.toLowerCase() == dayName);

    return isDayAvailable;
  }

  bool _isDayBooked(DateTime day, List<DateTime?> bookedDates) {
    return bookedDates!.any((bookedDate) => isSameDay(bookedDate, day));
  }

  Future<void> _selectMonth() async {
    final selectedMonth = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: _months.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_months[index]),
              onTap: () => Navigator.pop(context, index + 1),
            );
          },
        );
      },
    );
    if (selectedMonth != null) {
      setState(() {
        _focusedDay = DateTime(_focusedDay.year, selectedMonth, 1);
      });
    }
  }

  Future<void> _selectYear() async {
    final currentYear = DateTime.now().year;
    final selectedYear = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: 101,
          itemBuilder: (context, index) {
            final year = currentYear + index - 50;
            return ListTile(
              title: Text(year.toString()),
              onTap: () => Navigator.pop(context, year),
            );
          },
        );
      },
    );
    if (selectedYear != null) {
      setState(() {
        _focusedDay = DateTime(selectedYear, _focusedDay.month, 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        String yearAndMonth = DateFormat('yyyy-MM').format(_selectedDay);
        final asyncBookedDates =
            ref.watch(fetchBookedDatesProvider(yearAndMonth));
        return asyncBookedDates.when(
          data: (bookedDates) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(
                              _focusedDay.year,
                              _focusedDay.month - 1,
                              1,
                            );
                          });
                        },
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _selectMonth,
                            child: Text(
                              _months[_focusedDay.month - 1],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _selectYear,
                            child: Text(
                              _focusedDay.year.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(
                              _focusedDay.year,
                              _focusedDay.month + 1,
                              1,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TableCalendar(
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2050),
                    focusedDay: _focusedDay,
                    currentDay: DateTime.now(),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: CalendarFormat.month,
                    enabledDayPredicate: _isDaySelectable,
                    onDaySelected: (selectedDay, focusedDay) {
                      if (_isDaySelectable(selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        if (widget.onDaySelected != null) {
                          widget.onDaySelected!(selectedDay, focusedDay);
                        }
                      }
                    },
                    headerVisible: false,
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      todayDecoration: BoxDecoration(
                        color: Colors.red.shade100,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      defaultDecoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      disabledDecoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      outsideDaysVisible: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, _) {
                        if (bookedDates.isEmpty) {
                          bookedDates = [];
                        }
                        if (_isDayBooked(day, bookedDates)) {
                          return Positioned(
                            bottom: 1,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => Center(child: LoadingAnimation()),
          error: (error, stackTrace) {
            return Center(
              child: Text("Failed to load Calender"),
            );
          },
        );
      },
    );
  }
}
