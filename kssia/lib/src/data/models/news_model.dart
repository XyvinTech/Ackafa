class News {
  final String id;
  final String category;
  final String title;
  final String image;
  final String content;

  News({
    required this.id,
    required this.category,
    required this.title,
    required this.image,
    required this.content,
  });

  News copyWith({
    String? id,
    String? category,
    String? title,
    String? image,
    String? content,
  }) {
    return News(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      image: image ?? this.image,
      content: content ?? this.content,
    );
  }


  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['_id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      content: json['content'] as String,
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category,
      'title': title,
      'image': image,
      'content': content,
    };
  }
}
