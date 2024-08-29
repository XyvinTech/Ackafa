class NotificationModel {
  final String? id;
  final List<String>? to;
  final String? subject;
  final String? content;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.to,
    this.subject,
    this.content,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  NotificationModel copyWith({
    String? id,
    List<String>? to,
    String? subject,
    String? content,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      to: to ?? this.to,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String?,
      to: (json['to'] as List<dynamic>?)?.map((e) => e as String).toList(),
      subject: json['subject'] as String?,
      content: json['content'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'to': to,
      'subject': subject,
      'content': content,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
