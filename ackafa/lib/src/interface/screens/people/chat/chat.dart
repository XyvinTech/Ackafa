import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/chat_model.dart';
import 'package:ackaf/src/data/models/msg_model.dart';
import 'package:ackaf/src/data/services/api_routes/chat_api.dart';
import 'package:ackaf/src/interface/screens/people/chat/chatscreen.dart';

class ChatPage extends StatelessWidget {
  ChatModel sourcChat = ChatModel(
      name: '',
      icon: '',
      time: '',
      currentMessage: '',
      id: id,
      unreadMessages: 0);

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final chats = ref.watch(fetchChatThreadProvider(token)).value ??
          [
            ChatModel(
              name: 'Loading...',
              icon: '',
              time: '',
              currentMessage: '',
              id: '',
              unreadMessages: 0,
            ),
          ];
      return Scaffold(
        body: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(chats[index].icon),
              ),
              title: Text(chats[index].name),
              subtitle: Text(chats[index].currentMessage),
              trailing: chats[index].unreadMessages > 0
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '${chats[index].unreadMessages}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => IndividualPage(
                          chatModel: chats[index],
                          sourchat: sourcChat,
                        )));
              },
            );
          },
        ),
      );
    });
  }
}
