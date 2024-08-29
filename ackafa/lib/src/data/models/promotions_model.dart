class Promotion {
  final String id;
  final String type;
  final String bannerImageUrl;
  final String uploadVideo;
  final String posterImageUrl;
  final bool status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String videoTitle;
  final String ytLink;
  final String noticeTitle;
  final String noticeDescription;
  final String noticeLink;

  Promotion(
      {required this.id,
      required this.type,
      required this.bannerImageUrl,
      required this.uploadVideo,
      required this.posterImageUrl,
      required this.status,
      required this.startDate,
      required this.endDate,
      required this.createdAt,
      required this.updatedAt,
      required this.videoTitle,
      required this.ytLink,
      this.noticeTitle = '',
      this.noticeDescription = '',
      this.noticeLink = ''});

  Promotion copyWith(
      {String? id,
      String? type,
      String? bannerImageUrl,
      String? uploadVideo,
      String? posterImageUrl,
      bool? status,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? videoTitle,
      String? ytLink,
      String? noticeTitle,
      String? noticeDescription,
      String? noticeLink}) {
    return Promotion(
        id: id ?? this.id,
        type: type ?? this.type,
        bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
        uploadVideo: uploadVideo ?? this.uploadVideo,
        posterImageUrl: posterImageUrl ?? this.posterImageUrl,
        status: status ?? this.status,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        videoTitle: videoTitle ?? this.videoTitle,
        ytLink: ytLink ?? this.ytLink,
        noticeTitle: noticeTitle ?? this.noticeTitle,
        noticeDescription: noticeDescription ?? this.noticeDescription,
        noticeLink: noticeLink ?? this.noticeLink);
  }

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
        id: json["_id"],
        type: json["type"],
        bannerImageUrl: json["banner_image_url"] ?? '',
        uploadVideo: json["upload_video"] ?? '',
        posterImageUrl: json["poster_image_url"] ?? '',
        status: json["status"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        videoTitle: json["video_title"] ?? '',
        ytLink: json["yt_link"] ?? '',
        noticeTitle: json["notice_title"] ?? '',
        noticeDescription: json["notice_description"] ?? '',
        noticeLink: json["notice_link"] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "type": type,
      "banner_image_url": bannerImageUrl,
      "upload_video": uploadVideo,
      "poster_image_url": posterImageUrl,
      "status": status,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "video_title": videoTitle,
      "yt_link": ytLink,
      "notice_title": noticeTitle,
      "notice_description": noticeDescription,
      "notice_link": noticeLink
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Promotion &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          bannerImageUrl == other.bannerImageUrl &&
          uploadVideo == other.uploadVideo &&
          posterImageUrl == other.posterImageUrl &&
          status == other.status &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          videoTitle == other.videoTitle &&
          ytLink == other.ytLink &&
          noticeTitle == other.noticeTitle &&
          noticeDescription == other.noticeDescription &&
          noticeLink == other.noticeLink;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      bannerImageUrl.hashCode ^
      uploadVideo.hashCode ^
      posterImageUrl.hashCode ^
      status.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      videoTitle.hashCode ^
      ytLink.hashCode ^
      noticeTitle.hashCode ^
      noticeDescription.hashCode ^
      noticeLink.hashCode;
}
