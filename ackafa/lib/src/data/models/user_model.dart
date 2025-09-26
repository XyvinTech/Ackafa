class UserModel {
  final String? fullName;
  final String? emiratesID;
  final String? id;
  final String? uid;
  final UserCollege? college;
  final UserCourse? course;
  final int? batch;
  final String? role;
  final String? image;
  final String? email;
  final String? phone;
  final String? bio;
  final String? status;
  final String? gender;
  final int? otp;
  final String? address;
  final Company? company;
  final List<Link>? social;
  final List<Link>? websites;
  final List<Award>? awards;
  final List<Link>? videos;
  final List<Link>? certificates;
  final String? reason;
  final String? profileCompletion;
  final String? memberId;
  final List<String>? blockedUsers;

  UserModel(
      {this.fullName,
      this.emiratesID,
      this.id,
      this.uid,
      this.college,
      this.course,
      this.batch,
      this.role,
      this.image,
      this.email,
      this.phone,
      this.bio,
      this.status,
      this.otp,
      this.address,
      this.company,
      this.social,
      this.websites,
      this.awards,
      this.videos,
      this.certificates,
      this.reason,
      this.profileCompletion,
      this.memberId,
      this.blockedUsers,
      this.gender
      });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      id: json['_id'],
      emiratesID: json['emiratesID'],
      uid: json['uid'],
      college: json['college'] != null
          ? UserCollege.fromJson(json['college'])
          : null,
      course:
          json['course'] != null ? UserCourse.fromJson(json['course']) : null,
      batch: json['batch'],
      role: json['role'] ?? 'member',
      image: json['image'],
      email: json['email'],
      phone: json['phone'],
      bio: json['bio'],
      status: json['status'] ?? 'inactive',
      otp: json['otp'],
      address: json['address'],
      company:
          json['company'] != null ? Company.fromJson(json['company']) : null,
      social: json['social'] != null
          ? (json['social'] as List).map((item) => Link.fromJson(item)).toList()
          : null,
      websites: json['websites'] != null
          ? (json['websites'] as List)
              .map((item) => Link.fromJson(item))
              .toList()
          : null,
      awards: json['awards'] != null
          ? (json['awards'] as List)
              .map((item) => Award.fromJson(item))
              .toList()
          : null,
      videos: json['videos'] != null
          ? (json['videos'] as List).map((item) => Link.fromJson(item)).toList()
          : null,
      certificates: json['certificates'] != null
          ? (json['certificates'] as List)
              .map((item) => Link.fromJson(item))
              .toList()
          : null,
      reason: json['reason'],
      profileCompletion: json['profileCompletion'] as String?,
      memberId: json['memberId'],
      blockedUsers: (json['blockedUsers'] as List?)
          ?.map((item) => item as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': fullName,
      '_id': id?.toString(),
      'uid': uid,
      'college': college,
      'course': college,
      'batch': batch,
      'role': role,
      'image': image,
      'email': email,
      'phone': phone,
      'bio': bio,
      'status': status,
      'otp': otp,
      'address': address,
      'company': company?.toJson(),
      'social': social?.map((item) => item.toJson()).toList(),
      'websites': websites?.map((item) => item.toJson()).toList(),
      'awards': awards?.map((item) => item.toJson()).toList(),
      'videos': videos?.map((item) => item.toJson()).toList(),
      'certificates': certificates?.map((item) => item.toJson()).toList(),
      'reason': reason,
      'profileCompletion': profileCompletion,
      'memberId': memberId,
      'blockedUsers': blockedUsers,
      'gender' : gender
    };
  }

  UserModel copyWith(
      {String? fullName,
      String? emiratesID,
      String? id,
      String? uid,
      UserCollege? college,
      UserCourse? course,
      int? batch,
      String? role,
      String? image,
      String? email,
      String? phone,
      String? bio,
      String? status,
      String? gender,
      int? otp,
      String? address,
      Company? company,
      List<Link>? social,
      List<Link>? websites,
      List<Award>? awards,
      List<Link>? videos,
      List<Link>? certificates,
      String? reason,
      String? profileCompletion,
      String? memberId,
      List<String>? blockedUsers}) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      emiratesID: emiratesID ?? this.emiratesID,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      college: college ?? this.college,
      course: course ?? this.course,
      batch: batch ?? this.batch,
      role: role ?? this.role,
      image: image ?? this.image,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      status: status ?? this.status,
      otp: otp ?? this.otp,
      address: address ?? this.address,
      company: company ?? this.company,
      social: social ?? this.social,
      websites: websites ?? this.websites,
      awards: awards ?? this.awards,
      videos: videos ?? this.videos,
      certificates: certificates ?? this.certificates,
      reason: reason ?? this.reason,
      profileCompletion: profileCompletion ?? this.profileCompletion,
      memberId: memberId ?? this.memberId,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      gender: gender ?? this.gender,
    );
  }
}

class Company {
  final String? name;
  final String? designation;
  final String? phone;
  final String? address;
  final String? logo;

  Company({
    this.name,
    this.designation,
    this.phone,
    this.address,
    this.logo,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      designation: json['designation'],
      phone: json['phone'],
      address: json['address'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'phone': phone,
      'address': address,
      'logo': logo
    };
  }

  Company copyWith({
    String? name,
    String? designation,
    String? phone,
    String? address,
    String? logo,
  }) {
    return Company(
        name: name ?? this.name,
        designation: designation ?? this.designation,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        logo: logo ?? this.logo);
  }
}

class Award {
  final String? image;
  final String? name;
  final String? authority;

  Award({this.image, this.name, this.authority});

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      image: json['image'],
      name: json['name'],
      authority: json['authority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'authority': authority,
    };
  }

  Award copyWith({
    String? image,
    String? name,
    String? authority,
  }) {
    return Award(
      image: image ?? this.image,
      name: name ?? this.name,
      authority: authority ?? this.authority,
    );
  }
}

class Link {
  final String? name;
  final String? link;

  Link({this.name, this.link});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      name: json['name'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'link': link,
    };
  }

  Link copyWith({
    String? name,
    String? link,
  }) {
    return Link(
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }
}

class UserCollege {
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
  final List<String>? course;

  UserCollege({
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

  factory UserCollege.fromJson(Map<String, dynamic> json) {
    return UserCollege(
      id: json['_id'] as String?,
      collegeName: json['collegeName'] as String?,
      startYear: json['startYear'] as int?,
      batch: (json['batch'] as List<dynamic>?)?.map((e) => e as int).toList(),
      country: json['country'] as String?,
      state: json['state'] as String?,
      status: json['status'] as bool?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
      course:
          (json['course'] as List<dynamic>?)?.map((e) => e as String).toList(),
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
      'course': course,
    };
  }

  UserCollege copyWith({
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
    List<String>? course,
  }) {
    return UserCollege(
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

class UserCourse {
  final String? id;
  final String? courseName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  UserCourse({
    this.id,
    this.courseName,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UserCourse.fromJson(Map<String, dynamic> json) {
    return UserCourse(
      id: json['_id'] as String?,
      courseName: json['courseName'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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

  UserCourse copyWith({
    String? id,
    String? courseName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return UserCourse(
      id: id ?? this.id,
      courseName: courseName ?? this.courseName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
