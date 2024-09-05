class Speaker {
  final String? name;
  final String? designation;
  final String? role;
  final String? image;
  final String? id;

  Speaker({
    this.name,
    this.designation,
    this.role,
    this.image,
    this.id,
  });

  // fromJson
  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      name: json['name'] as String?,
      designation: json['designation'] as String?,
      role: json['role'] as String?,
      image: json['image'] as String?,
      id: json['_id'] as String?,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'role': role,
      'image': image,
      '_id': id,
    };
  }
}

class Event {
  final String? id;
  final String? eventName;
  final String? type;
  final String? image;
  final DateTime? startDate;
  final DateTime? startTime;
  final DateTime? endDate;
  final DateTime? endTime;
  final String? platform;
  final String? link;
  final String? venue;
  final List<Speaker>? speakers;
  final String? status;
  final List<dynamic>? rsvp;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Event({
    this.id,
    this.eventName,
    this.type,
    this.image,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.platform,
    this.link,
    this.venue,
    this.speakers,
    this.status,
    this.rsvp,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  // fromJson
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] as String?,
      eventName: json['eventName'] as String?,
      type: json['type'] as String?,
      image: json['image'] as String?,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      platform: json['platform'] as String?,
      link: json['link'] as String?,
      venue: json['venue'] as String?,
      speakers: json['speakers'] != null
          ? List<Speaker>.from(json['speakers'].map((x) => Speaker.fromJson(x)))
          : [],
      status: json['status'] as String?,
      rsvp: json['rsvp'] != null ? List<dynamic>.from(json['rsvp']) : [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'eventName': eventName,
      'type': type,
      'image': image,
      'startDate': startDate?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'platform': platform,
      'link': link,
      'venue': venue,
      'speakers': speakers?.map((x) => x.toJson()).toList(),
      'status': status,
      'rsvp': rsvp ?? [],
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }

  // copyWith
  Event copyWith({
    String? id,
    String? eventName,
    String? type,
    String? image,
    DateTime? startDate,
    DateTime? startTime,
    DateTime? endDate,
    DateTime? endTime,
    String? platform,
    String? link,
    String? venue,
    List<Speaker>? speakers,
    String? status,
    List<dynamic>? rsvp,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Event(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      type: type ?? this.type,
      image: image ?? this.image,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      endDate: endDate ?? this.endDate,
      endTime: endTime ?? this.endTime,
      platform: platform ?? this.platform,
      link: link ?? this.link,
      venue: venue ?? this.venue,
      speakers: speakers ?? this.speakers,
      status: status ?? this.status,
      rsvp: rsvp ?? this.rsvp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
