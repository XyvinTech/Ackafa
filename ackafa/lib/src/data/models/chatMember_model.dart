import 'package:meta/meta.dart';

class GroupMember {
  final String? id;
  final String? name;
  final String? phone;
  final int? batch;
  final String? college;
  final String? memberId;
  final String? status;

  GroupMember({
    this.id,
    this.name,
    this.phone,
    this.batch,
    this.college,
    this.memberId,
    this.status,
  });

  // fromJson constructor to handle JSON conversion
  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      batch: json['batch'] as int?,
      college: json['college'] as String?,
      memberId: json['memberId'] as String?,
      status: json['status'] as String?,
    );
  }

  // toJson method to convert object to JSON format
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'batch': batch,
      'college': college,
      'memberId': memberId,
      'status': status,
    };
  }

  // copyWith method for updating specific fields
  GroupMember copyWith({
    String? id,
    String? name,
    String? phone,
    int? batch,
    String? college,
    String? memberId,
    String? status,
  }) {
    return GroupMember(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      batch: batch ?? this.batch,
      college: college ?? this.college,
      memberId: memberId ?? this.memberId,
      status: status ?? this.status,
    );
  }
}
