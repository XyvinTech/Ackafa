import 'package:ackaf/src/data/models/user_model.dart';

class Feed {
  String? id;
  String? type;
  String? media;
  String? link;
  String? content;
  String? author;
  List<String>? likes;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Comment>? comments;

  Feed({
    this.id,
    this.type,
    this.media,
    this.link,
    this.content,
    this.author,
    this.likes,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.comments,
  });

  // fromJson method to parse JSON data
  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['_id'] as String?,
      type: json['type'] as String?,
      media: json['media'] as String?,
      link: json['link'] as String?,
      content: json['content'] as String?,
      author: json['author'] as String?,
      likes: (json['like'] as List?)?.map((item) => item as String).toList(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      comments: (json['comment'] as List?)
          ?.map((item) => Comment.fromJson(item))
          .toList(),
    );
  }

  // toJson method to convert object to JSON format
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'media': media,
      'link': link,
      'content': content,
      'author': author,
      'like': likes,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'comment': comments?.map((item) => item.toJson()).toList(),
    };
  }
}

// Comment model with fromJson and toJson methods
class Comment {
  FeedUser? user;
  String? comment;

  Comment({this.user, this.comment});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'] != null ? FeedUser.fromJson(json['user']) : null,
      comment: json['comment'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'comment': comment,
    };
  }
}

// User model with fromJson and toJson methods
class FeedUser {
  String? id;
  String? image;
  Name? name;

  FeedUser({this.id, this.image, this.name});

  factory FeedUser.fromJson(Map<String, dynamic> json) {
    return FeedUser(
      id: json['_id'] as String?,
      image: json['image'] as String?,
      name: json['name'] != null ? Name.fromJson(json['name']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'image': image,
      'name': name?.toJson(),
    };
  }
}

