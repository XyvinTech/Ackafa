// class UserRequirementModel {
//   final String id;
//   final String author;
//   final String image;
//   final String content;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final String? reason;

//   const UserRequirementModel({
//     required this.id,
//     required this.author,
//     required this.image,
//     required this.content,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     this.reason,
//   });

//   UserRequirementModel copyWith({
//     String? id,
//     String? author,
//     String? image,
//     String? content,
//     String? status,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     String? reason,
//   }) {
//     return UserRequirementModel(
//       id: id ?? this.id,
//       author: author ?? this.author,
//       image: image ?? this.image,
//       content: content ?? this.content,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       reason: reason ?? this.reason,
//     );
//   }

//   factory UserRequirementModel.fromJson(Map<String, dynamic> json) {
//     return UserRequirementModel(
//       id: json["_id"],
//       author: json["author"],
//       image: json["image"],
//       content: json["content"],
//       status: json["status"],
//       createdAt: DateTime.parse(json["createdAt"]),
//       updatedAt: DateTime.parse(json["updatedAt"]),
//       reason: json["reason"],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "author": author,
//       "image": image,
//       "content": content,
//       "status": status,
//       "createdAt": createdAt.toIso8601String(),
//       "updatedAt": updatedAt.toIso8601String(),
//       "reason": reason,
//     };
//   }
// }
