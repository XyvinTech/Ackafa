

class Name {
  final String? firstName;
  final String? middleName;
  final String? lastName;

  Name({
    this.firstName,
    this.middleName,
    this.lastName,
  });

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
}

class PhoneNumbers {
  final int? personal;
  final int? landline;
  final int? companyPhoneNumber;
  final int? whatsappNumber;
  final int? whatsappBusinessNumber;

  PhoneNumbers({
    this.personal,
    this.landline,
    this.companyPhoneNumber,
    this.whatsappNumber,
    this.whatsappBusinessNumber,
  });

  factory PhoneNumbers.fromJson(Map<String, dynamic> json) {
    return PhoneNumbers(
      personal: json['personal'] as int?,
      landline: json['landline'] as int?,
      companyPhoneNumber: json['company_phone_number'] as int?,
      whatsappNumber: json['whatsapp_number'] as int?,
      whatsappBusinessNumber: json['whatsapp_business_number'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personal': personal,
      'landline': landline,
      'company_phone_number': companyPhoneNumber,
      'whatsapp_number': whatsappNumber,
      'whatsapp_business_number': whatsappBusinessNumber,
    };
  }

  PhoneNumbers copyWith({
    int? personal,
    int? landline,
    int? companyPhoneNumber,
    int? whatsappNumber,
    int? whatsappBusinessNumber,
  }) {
    return PhoneNumbers(
      personal: personal ?? this.personal,
      landline: landline ?? this.landline,
      companyPhoneNumber: companyPhoneNumber ?? this.companyPhoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      whatsappBusinessNumber:
          whatsappBusinessNumber ?? this.whatsappBusinessNumber,
    );
  }
}

class Website {
  final String? name;
  final String? url;

  Website({
    this.name,
    this.url,
  });

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  Website copyWith({
    String? name,
    String? url,
  }) {
    return Website(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }
}

class SocialMedia {
  final String? platform;
  final String? url;
  final String? id;

  SocialMedia({
    this.platform,
    this.url,
    this.id,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      platform: json['platform'] as String?,
      url: json['url'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
      '_id': id,
    };
  }

  SocialMedia copyWith({
    String? platform,
    String? url,
    String? id,
  }) {
    return SocialMedia(
      platform: platform ?? this.platform,
      url: url ?? this.url,
      id: id ?? this.id,
    );
  }
}

class Video {
  final String? name;
  final String? url;

  Video({
    required this.name,
    required this.url,
  });

  Video copyWith({
    String? name,
    String? url,
  }) {
    return Video(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class Award {
  final String? name;
  final String? url;
  final String? authorityName;

  Award({required this.name, required this.url, required this.authorityName});

  Award copyWith({String? name, String? url, String? authorityName}) {
    return Award(
      name: name ?? this.name,
      url: url ?? this.url,
      authorityName: authorityName ?? this.authorityName,
    );
  }

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      name: json['name'],
      url: json['url'],
      authorityName: json['authority_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url, 'authority_name': authorityName};
  }
}

class Certificate {
  final String? name;
  final String? url;

  Certificate({
    required this.name,
    required this.url,
  });

  Certificate copyWith({
    String? name,
    String? url,
  }) {
    return Certificate(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class Brochure {
  final String? name;
  final String? url;

  Brochure({
    required this.name,
    required this.url,
  });

  Brochure copyWith({
    String? name,
    String? url,
  }) {
    return Brochure(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  factory Brochure.fromJson(Map<String, dynamic> json) {
    return Brochure(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class UserModel {
  final String? id;
  final String? membershipId;
  final Name? name;
  final PhoneNumbers? phoneNumbers;
  final String? bloodGroup;
  final String? email;
  final String? designation;
  final String? companyName;
  final String? companyEmail;
  final String? businessCategory;
  final String? subCategory;
  final String? bio;
  final String? address;
  final List<Website>? websites;
  final String? status;
  final bool? isActive;
  final bool? isDeleted;
  final String? selectedTheme;
  final List<SocialMedia>? socialMedia;
  final List<Video>? video;
  final List<Award>? awards;
  final List<Certificate>? certificates;
  final List<Brochure>? brochure;
  final List<Review>? reviews; // Added reviews field
  final String? createdAt;
  final String? updatedAt;
  final String? companyAddress;
  final String? companyLogo;
  final String? profilePicture;

  UserModel({
    this.id,
    this.membershipId,
    this.name,
    this.phoneNumbers,
    this.bloodGroup,
    this.email,
    this.designation,
    this.companyName,
    this.companyEmail,
    this.businessCategory,
    this.subCategory,
    this.bio,
    this.address,
    this.websites,
    this.status,
    this.isActive,
    this.isDeleted,
    this.selectedTheme,
    this.socialMedia,
    this.video,
    this.awards,
    this.certificates,
    this.brochure,
    this.reviews, // Initialize reviews
    this.createdAt,
    this.updatedAt,
    this.companyAddress,
    this.companyLogo,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String?,
      membershipId: json['membership_id'] as String?,
      name: json['name'] != null ? Name.fromJson(json['name']) : null,
      phoneNumbers: json['phone_numbers'] != null
          ? PhoneNumbers.fromJson(json['phone_numbers'])
          : null,
      bloodGroup: json['blood_group'] as String?,
      email: json['email'] as String?,
      designation: json['designation'] as String?,
      companyName: json['company_name'] as String?,
      companyEmail: json['company_email'] as String?,
      businessCategory: json['business_category'] as String?,
      subCategory: json['sub_category'] as String?,
      bio: json['bio'] as String?,
      address: json['address'] as String?,
      websites: (json['websites'] as List<dynamic>?)
          ?.map((e) => Website.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      isActive: json['is_active'] as bool?,
      isDeleted: json['is_deleted'] as bool?,
      selectedTheme: json['selectedTheme'] as String?,
      socialMedia: (json['social_media'] as List<dynamic>?)
          ?.map((e) => SocialMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      video: (json['video'] as List<dynamic>?)
          ?.map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList(),
      awards: (json['awards'] as List<dynamic>?)
          ?.map((e) => Award.fromJson(e as Map<String, dynamic>))
          .toList(),
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((e) => Certificate.fromJson(e as Map<String, dynamic>))
          .toList(),
      brochure: (json['brochure'] as List<dynamic>?)
          ?.map((e) => Brochure.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(), // Parse reviews
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      companyAddress: json['company_address'] as String?,
      companyLogo: json['company_logo'] as String?,
      profilePicture: json['profile_picture'] as String?,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'membership_id': membershipId,
      'name': name?.toJson(),
      'phone_numbers': phoneNumbers?.toJson(),
      'blood_group': bloodGroup,
      'email': email,
      'designation': designation,
      'company_name': companyName,
      'company_email': companyEmail,
      'business_category': businessCategory,
      'sub_category': subCategory,
      'bio': bio,
      'address': address,
      'websites': websites?.map((e) => e.toJson()).toList(),
      'status': status,
      'is_active': isActive,
      'is_deleted': isDeleted,
      'selectedTheme': selectedTheme,
      'social_media': socialMedia?.map((e) => e.toJson()).toList(),
      'video': video?.map((e) => e.toJson()).toList(),
      'awards': awards?.map((e) => e.toJson()).toList(),
      'certificates': certificates?.map((e) => e.toJson()).toList(),
      'brochure': brochure?.map((e) => e.toJson()).toList(),
      'reviews': reviews?.map((e) => e.toJson()).toList(), // Serialize reviews
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'company_address': companyAddress,
      'company_logo': companyLogo,
      'profile_picture': profilePicture,
    
    };
  }

  UserModel copyWith({
    String? id,
    String? membershipId,
    Name? name,
    PhoneNumbers? phoneNumbers,
    String? bloodGroup,
    String? email,
    String? designation,
    String? companyName,
    String? companyEmail,
    String? businessCategory,
    String? subCategory,
    String? bio,
    String? address,
    List<Website>? websites,
    String? status,
    bool? isActive,
    bool? isDeleted,
    String? selectedTheme,
    List<SocialMedia>? socialMedia,
    List<Video>? video,
    List<Award>? awards,
    List<Certificate>? certificates,
    List<Brochure>? brochure,
    List<Review>? reviews, // Add reviews parameter
    String? createdAt,
    String? updatedAt,
    String? companyAddress,
    String? companyLogo,
    String? profilePicture,

  }) {
    return UserModel(
      id: id ?? this.id,
      membershipId: membershipId ?? this.membershipId,
      name: name ?? this.name,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      email: email ?? this.email,
      designation: designation ?? this.designation,
      companyName: companyName ?? this.companyName,
      companyEmail: companyEmail ?? this.companyEmail,
      businessCategory: businessCategory ?? this.businessCategory,
      subCategory: subCategory ?? this.subCategory,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      websites: websites ?? this.websites,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      socialMedia: socialMedia ?? this.socialMedia,
      video: video ?? this.video,
      awards: awards ?? this.awards,
      certificates: certificates ?? this.certificates,
      brochure: brochure ?? this.brochure,
      reviews: reviews ?? this.reviews, // Assign reviews
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      companyAddress: companyAddress ?? this.companyAddress,
      companyLogo: companyLogo ?? this.companyLogo,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}

class Review {
  final String? reviewer;
  final String? content;
  final int? rating;
  final String? id;
  final String? createdAt;

  Review({
    this.reviewer,
    this.content,
    this.rating,
    this.id,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewer: json['reviewer'] as String?,
      content: json['content'] as String?,
      rating: json['rating'] as int?,
      id: json['_id'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewer': reviewer,
      'content': content,
      'rating': rating,
      '_id': id,
      'created_at': createdAt,
    };
  }

  Review copyWith({
    String? reviewer,
    String? content,
    int? rating,
    String? id,
    String? createdAt,
  }) {
    return Review(
      reviewer: reviewer ?? this.reviewer,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
