class MessageModel {
  String status;
  String message;
  String time;
  String fromId;

  MessageModel(
      {required this.message,
      required this.status,
      required this.fromId,
      required this.time});
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['content'],
      status: json['status'],
      time: json['timestamp']
          .toString()
          .split('T')[1]
          .split('.')[0]
          .substring(0, 5),
      fromId: json['from'],
    );
  }
}
