class Event {
  String? id;
  String? type;
  String? name;
  String? image;
  DateTime? date;
  DateTime? time;
  String? platform;
  String? meetingLink;
  String? organiserName;
  String? organiserCompanyName;
  String? guestImage;
  String? organiserRole;
  bool? activate;
  List<Speaker>? speakers;

  Event({
    this.id,
    this.type,
    this.name,
    this.image,
    this.date,
    this.time,
    this.platform,
    this.meetingLink,
    this.organiserName,
    this.organiserCompanyName,
    this.guestImage,
    this.organiserRole,
    this.activate,
    this.speakers,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      type: json['type'],
      name: json['name'],
      image: json['image'],
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
      platform: json['platform'],
      meetingLink: json['meeting_link'],
      organiserName: json['organiser_name'],
      organiserCompanyName: json['organiser_company_name'],
      guestImage: json['guest_image'],
      organiserRole: json['organiser_role'],
      activate: json['activate'],
      speakers: (json['speakers'] as List)
          .map((speakerJson) => Speaker.fromJson(speakerJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'name': name,
      'image': image,
      'date': date?.toIso8601String(),
      'time': time?.toIso8601String(),
      'platform': platform,
      'meeting_link': meetingLink,
      'organiser_name': organiserName,
      'organiser_company_name': organiserCompanyName,
      'guest_image': guestImage,
      'organiser_role': organiserRole,
      'activate': activate,
      'speakers': speakers?.map((speaker) => speaker.toJson()).toList(),
    };
  }
}

class Speaker {
  String? id;
  String? speakerName;
  String? speakerDesignation;
  String? speakerImage;
  String? speakerRole;

  Speaker({
    this.id,
    this.speakerName,
    this.speakerDesignation,
    this.speakerImage,
    this.speakerRole,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json['_id'],
      speakerName: json['speaker_name'],
      speakerDesignation: json['speaker_designation'],
      speakerImage: json['speaker_image'],
      speakerRole: json['speaker_role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'speaker_name': speakerName,
      'speaker_designation': speakerDesignation,
      'speaker_image': speakerImage,
      'speaker_role': speakerRole,
    };
  }
}
