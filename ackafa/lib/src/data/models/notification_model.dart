class NotificationModel {
  String? id;
  List<User>? users;
  String? subject;
  String? content;
  String? media;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? version;

  NotificationModel({
    this.id,
    this.users,
    this.subject,
    this.content,
    this.media,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      users: json['users'] != null
          ? List<User>.from(json['users'].map((x) => User.fromJson(x)))
          : null,
      subject: json['subject'],
      content: json['content'],
      media: json['media'],
      type: json['type'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'users': users != null
          ? List<dynamic>.from(users!.map((x) => x.toJson()))
          : null,
      'subject': subject,
      'content': content,
      'media': media,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }
}

class User {
  String? user;
  bool? read;
  String? id;

  User({this.user, this.read, this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user: json['user'],
      read: json['read'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'read': read,
      '_id': id,
    };
  }
}
