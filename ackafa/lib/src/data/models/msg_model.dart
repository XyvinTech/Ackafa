class MessageModel {
  final String? id;
  final String? from;
  final String? to;
  final String? content;
  final List<MessageAttachment>? attachments;
  final ChatFeed? feed;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  MessageModel({
    this.id,
    this.from,
    this.to,
    this.content,
    this.attachments,
    this.feed,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  // fromJson method
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String?,
      from: json['from'] as String?,
      to: json['to'] as String?,
      content: json['content'] as String?,
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((e) => MessageAttachment.fromJson(e))
              .toList()
          : null,
      feed: json['feed'] != null ? ChatFeed.fromJson(json['feed']) : null,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'from': from,
      'to': to,
      'content': content,
      'attachments': attachments?.map((e) => e.toJson()).toList(),
      'feed': feed?.toJson(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class MessageAttachment {
  final String? url;
  final String? type;

  MessageAttachment({this.url, this.type});

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      url: json['url'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'type': type,
    };
  }
}

class ChatFeed {
  final String? id;
  final String? media;

  ChatFeed({
    this.id,
    this.media,
  });

  // fromJson method
  factory ChatFeed.fromJson(Map<String, dynamic> json) {
    return ChatFeed(
      id: json['_id'] as String?,
      media: json['media'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'media': media,
    };
  }
}
