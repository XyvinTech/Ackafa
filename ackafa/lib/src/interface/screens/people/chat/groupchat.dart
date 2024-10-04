import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/services/api_routes/group_api.dart';
import 'package:ackaf/src/interface/screens/people/chat/groupchatscreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ackaf/src/data/models/chat_model.dart';

import 'package:ackaf/src/data/services/api_routes/chat_api.dart';
import 'package:ackaf/src/interface/screens/people/chat/chatscreen.dart';

class GroupChatPage extends ConsumerStatefulWidget {
  GroupChatPage({super.key});

  @override
  ConsumerState<GroupChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<GroupChatPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final asyncGroups = ref.watch(getGroupListProvider);

      return Scaffold(
          backgroundColor: Colors.white,
          body: asyncGroups.when(
            data: (groups) {
              return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  var receiver = Participant(
                      id: groups[index].id,
                      name: Name(first: groups[index].groupName));

                  var sender = Participant(id: id);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(receiver?.image ?? ''),
                    ),
                    title: Text(
                        '${receiver?.name?.first ?? ''} ${receiver?.name?.middle ?? ''} ${receiver?.name?.last ?? ''}'),
                    subtitle: Text(groups[index].lastMessage ?? ''),
                    trailing: groups[index].unreadCount != 0 &&
                            groups[index].unreadCount != null
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
                                child: groups[index].unreadCount != null
                                    ? Text(
                                        '${groups[index].unreadCount}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : null,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Groupchatscreen(
                                group: receiver,
                                sender: sender,
                              )));
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              return Center(
                child: Text('Error loading promotions: $error'),
              );
            },
          ));
    });
  }
}
