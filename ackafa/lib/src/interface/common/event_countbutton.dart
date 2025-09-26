import 'dart:async';

import 'package:ackaf/src/data/models/events_model.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:flutter/material.dart';

class EventCountdownButton extends StatefulWidget {
  final Event event;
  final VoidCallback onPressed;

  const EventCountdownButton({
    Key? key,
    required this.event,
    required this.onPressed,
  }) : super(key: key);

  @override
  _EventCountdownButtonState createState() => _EventCountdownButtonState();
}

class _EventCountdownButtonState extends State<EventCountdownButton> {
  late Duration _remaining;
  late DateTime _eventStart;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _eventStart = DateTime.parse(widget.event.startTime.toString()).toLocal();
    _remaining = _eventStart.difference(DateTime.now());

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final diff = _eventStart.difference(DateTime.now());
      if (diff.isNegative) {
        timer.cancel();
      }
      setState(() {
        _remaining = diff.isNegative ? Duration.zero : diff;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return customButton(
      buttonHeight: 40,
      buttonWidth: 180,
      label: _remaining > Duration.zero
          ? _formatDuration(_remaining)
          : "Event Started",
      onPressed: widget.onPressed,
    );
  }
}
