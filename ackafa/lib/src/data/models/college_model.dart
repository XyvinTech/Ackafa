class College {
  final String? id;
  final String? collegeName;
  final int? startYear;
  final List<int>? batch;
  final String? country;
  final String? state;
  final bool? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final List<Course>? course;

  College({
    this.id,
    this.collegeName,
    this.startYear,
    this.batch,
    this.country,
    this.state,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.course,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json['_id'] as String?,
      collegeName: json['collegeName'] as String?,
      startYear: json['startYear'] as int?,
      batch: (json['batch'] as List<dynamic>?)?.map((e) => e as int).toList(),
      country: json['country'] as String?,
      state: json['state'] as String?,
      status: json['status'] as bool?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
      course: (json['course'] as List<dynamic>?)
          ?.map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'collegeName': collegeName,
      'startYear': startYear,
      'batch': batch,
      'country': country,
      'state': state,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'course': course?.map((e) => e.toJson()).toList(),
    };
  }

  College copyWith({
    String? id,
    String? collegeName,
    int? startYear,
    List<int>? batch,
    String? country,
    String? state,
    bool? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    List<Course>? course,
  }) {
    return College(
      id: id ?? this.id,
      collegeName: collegeName ?? this.collegeName,
      startYear: startYear ?? this.startYear,
      batch: batch ?? this.batch,
      country: country ?? this.country,
      state: state ?? this.state,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      course: course ?? this.course,
    );
  }
}

class Course {
  final String? id;
  final String? courseName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Course({
    this.id,
    this.courseName,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] as String?,
      courseName: json['courseName'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'courseName': courseName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }

  Course copyWith({
    String? id,
    String? courseName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Course(
      id: id ?? this.id,
      courseName: courseName ?? this.courseName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}