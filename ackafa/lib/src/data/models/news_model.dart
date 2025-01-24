class News {
  final String? id;
  final String? category;
  final String? title;
  final String? pdf;
  final String? content;
  final String? media;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  News({
    this.id,
    this.category,
    this.title,
    this.pdf,
    this.content,
    this.media,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  // fromJson
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['_id'] as String?,
      category: json['category'] as String?,
      title: json['title'] as String?,
      pdf: json['pdf'] as String?,
      content: json['content'] as String?,
      media: json['media'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category,
      'title': title,
      'pdf': pdf,
      'content': content,
      'media': media,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }

  // copyWith
  News copyWith({
    String? id,
    String? category,
    String? title,
    String? pdf,
    String? content,
    String? media,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return News(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      pdf: pdf ?? this.pdf,
      content: content ?? this.content,
      media: media ?? this.media,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
