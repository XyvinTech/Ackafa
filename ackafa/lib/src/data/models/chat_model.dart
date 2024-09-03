import 'package:ackaf/src/data/globals.dart' as globals;

class ChatModel {
  String name;
  String icon;
  String time;
  String currentMessage;
  bool select;
  String id;
  int unreadMessages;

  ChatModel({
    required this.name,
    required this.icon,
    required this.time,
    required this.currentMessage,
    this.select = false,
    required this.id,
    required this.unreadMessages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    String chatName = '';
    String chatIcon = '';
    String chatId = '';
    String currentMessage = '';
    int unreadMessages = 0;
    String time = '';

    if (json['participants'] != null) {
      json['participants'].forEach((element) {
        if (element['id'] != globals.id) {
          chatName = element['name']['first_name'] ?? '';
          chatIcon = element['profile_picture'] ?? '';
          chatId = element['_id'] ?? '';
        }
      });
    }

    if (json['lastMessage'] != null && json['lastMessage'].isNotEmpty) {
      currentMessage = json['lastMessage'][0]['content'] ?? '';
      time = json['lastMessage'][0]['timestamp']
              .toString()
              .split('T')[1]
              .split('.')[0]
              .substring(0, 5) ??
          '';
    } else {
      time = json['createdAt']
              .toString()
              .split('T')[1]
              .split('.')[0]
              .substring(0, 5) ??
          '';
    }

    if (json['unreadCount'] != null &&
        json['unreadCount'][globals.id] != null) {
      unreadMessages = json['unreadCount'][globals.id];
    }

    return ChatModel(
      name: chatName,
      icon: chatIcon,
      time: time,
      currentMessage: currentMessage,
      id: chatId,
      unreadMessages: unreadMessages,
    );
  }
}
