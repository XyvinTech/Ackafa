import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/services/api_routes/group_api.dart';
import 'package:ackaf/src/interface/common/loading.dart';
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
              if (groups.isNotEmpty) {
                return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    var receiver = Participant(
                        id: groups[index].id,
                        name: Name(first: groups[index].groupName));

                    var sender = Participant(id: id);
                    return ListTile(
                      leading: ClipOval(
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.red,
                          child: Image.network(
                            '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.groups_2,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),
                      title: Text(
                          '${receiver?.name?.first ?? ''} ${receiver?.name?.middle ?? ''} ${receiver?.name?.last ?? ''}'),
                      subtitle: Text(
                        groups[index].lastMessage != null
                            ? (groups[index].lastMessage!.length > 10
                                ? '${groups[index].lastMessage?.substring(0, groups[index].lastMessage!.length.clamp(0, 10))}...'
                                : groups[index].lastMessage!)
                            : '',
                      ),
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
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Image.asset('assets/nochat.png')),
                    ),
                    Text('No group chat yet!')
                  ],
                );
              }
            },
            loading: () => const Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              return Center(
                child: Text('No Groups'),
              );
            },
          ));
    });
  }
}
