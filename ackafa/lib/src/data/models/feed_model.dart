class Feed {
  final String? id;
  final String? type;
  final String? media;
  final String? link;
  final String? content;
  final List<dynamic>? like;
  final List<dynamic>? comment;
  final String? status;
  final String? author; // Added author field
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Feed({
    this.id,
    this.type,
    this.media,
    this.link,
    this.content,
    this.like,
    this.comment,
    this.status,
    this.author, // Initialize author
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  // fromJson
  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['_id'] as String?,
      type: json['type'] as String?,
      media: json['media'] as String?,
      link: json['link'] as String?,
      content: json['content'] as String?,
      like: json['like'] != null ? List<dynamic>.from(json['like']) : [],
      comment: json['comment'] != null ? List<dynamic>.from(json['comment']) : [],
      status: json['status'] as String?,
      author: json['author'] as String?, // Parse author
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'media': media,
      'link': link,
      'content': content,
      'like': like ?? [],
      'comment': comment ?? [],
      'status': status,
      'author': author, // Add author to JSON
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }

  // copyWith
  Feed copyWith({
    String? id,
    String? type,
    String? media,
    String? link,
    String? content,
    List<dynamic>? like,
    List<dynamic>? comment,
    String? status,
    String? author, // Include author in copyWith
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Feed(
      id: id ?? this.id,
      type: type ?? this.type,
      media: media ?? this.media,
      link: link ?? this.link,
      content: content ?? this.content,
      like: like ?? this.like,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      author: author ?? this.author, // Add author to copyWith
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}