class Requirement {
  final String? id;
  final Author? author;
  final String? image;
  final String? content;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Requirement({
    this.id,
    this.author,
    this.image,
    this.content,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Requirement copyWith({
    String? id,
    Author? author,
    String? image,
    String? content,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Requirement(
      id: id ?? this.id,
      author: author ?? this.author,
      image: image ?? this.image,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      id: json['_id'] as String?,
      author: json['author'] != null
          ? Author.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      image: json['image'] as String?,
      content: json['content'] as String?,
      status: json['status'] as String?,
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
      'author': author?.toJson(),
      'image': image,
      'content': content,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Author {
  final String? id;
  final Name? name;
  final String? email;

  Author({
    this.id,
    this.name,
    this.email,
  });

  Author copyWith({
    String? id,
    Name? name,
    String? email,
  }) {
    return Author(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'] as String?,
      name: json['name'] != null
          ? Name.fromJson(json['name'] as Map<String, dynamic>)
          : null,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name?.toJson(),
      'email': email,
    };
  }
}

class Name {
  final String? firstName;
  final String? middleName;
  final String? lastName;

  Name({
    this.firstName,
    this.middleName,
    this.lastName,
  });

  Name copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
  }) {
    return Name(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
    );
  }

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstName: json['first_name'] as String?,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
    };
  }
}
