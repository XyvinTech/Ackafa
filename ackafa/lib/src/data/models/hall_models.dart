class HallBooking {
  final String? id;
  final String? day;
  final Time? time;
  final String? status;
  final String? hall;
  final DateTime? date;
  final String? eventName;
  final String? description;
  final String? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  HallBooking({
    this.id,
    this.day,
    this.time,
    this.status,
    this.hall,
    this.date,
    this.eventName,
    this.description,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory HallBooking.fromJson(Map<String, dynamic> json) {
    return HallBooking(
      id: json['_id'] as String?,
      day: json['day'] as String?,
      time: json['time'] != null ? Time.fromJson(json['time']) : null,
      status: json['status'] as String?,
      hall: json['hall'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      eventName: json['eventName'] as String?,
      description: json['description'] as String?,
      user: json['user'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'day': day,
      'time': time?.toJson(),
      'status': status,
      'hall': hall,
      'date': date?.toIso8601String(),
      'eventName': eventName,
      'description': description,
      'user': user,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class Time {
  final String? start;
  final String? end;
  final String? id;

  Time({
    this.start,
    this.end,
    this.id,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      start: json['start'] as String?,
      end: json['end'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      '_id': id,
    };
  }
}


class Hall {
  final String name;
  final String address;

  Hall({
    required this.name,
    required this.address,
  });
}

class HallEvent {
  final String name;
  final String description;

  HallEvent({
    required this.name,
    required this.description,
  });
}
