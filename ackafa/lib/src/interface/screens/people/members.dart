import 'dart:developer';

import 'package:ackaf/src/data/models/chat_model.dart';
import 'package:ackaf/src/data/notifires/people_notifier.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/api_routes/chat_api.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/people/chat/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/interface/screens/profile/profilePreview.dart';

class MembersPage extends ConsumerStatefulWidget {
  const MembersPage({super.key});

  @override
  ConsumerState<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialUsers();
  }

  Future<void> _fetchInitialUsers() async {
    await ref.read(peopleNotifierProvider.notifier).fetchMoreUsers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(peopleNotifierProvider.notifier).fetchMoreUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(peopleNotifierProvider);
    final isLoading = ref.read(peopleNotifierProvider.notifier).isLoading;
    final asyncChats = ref.watch(fetchChatThreadProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        body: users.isEmpty
            ? Center(child: LoadingAnimation()) // Show loader when no data
            : asyncChats.when(
                data: (chats) {
                  log('im inside chat');
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: users.length +
                        (isLoading
                            ? 1
                            : 0), // Add 1 to show the loading indicator
                    itemBuilder: (context, index) {
                      if (index == users.length) {
                        // This is the loading indicator at the end of the list
                        return Center(
                          child:
                              LoadingAnimation(), // Show loading indicator when fetching more users
                        );
                      }

                      // Regular user item
                      var chatForUser = chats.firstWhere(
                        (chat) =>
                            chat.participants?.any((participant) =>
                                participant.id == users[index].id) ??
                            false,
                        orElse: () => ChatModel(
                          participants: [
                            Participant(
                              id: users[index].id,
                              name: users[index].name,
                              image: users[index].image,
                            ),
                            Participant(
                                id: id), // Replace with current user if needed
                          ],
                        ),
                      );

                      var receiver = chatForUser.participants?.firstWhere(
                        (participant) => participant.id != id,
                        orElse: () => Participant(
                          id: users[index].id,
                          name: users[index].name,
                          image: users[index].image,
                        ),
                      );

                      var sender = chatForUser.participants?.firstWhere(
                        (participant) => participant.id == id,
                        orElse: () => Participant(),
                      );

                      final user = users[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfilePreview(user: user),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipOval(
                              child: Image.network(
                                user.image ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/icons/dummy_person_small.png');
                                },
                              ),
                            ),
                          ),
                          title: Text(
                              '${user.name?.first ?? ''} ${user.name?.middle ?? ''} ${user.name?.last ?? ''}'),
                          subtitle: user.company?.designation != null
                              ? Text(user.company?.designation ?? '')
                              : null,
                          trailing: IconButton(
                            icon: Icon(Icons.chat),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => IndividualPage(
                                  receiver: receiver!,
                                  sender: sender!,
                                ),
                              ));
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(child: LoadingAnimation()),
                error: (error, stackTrace) {
                  return Center(
                    child: LoadingAnimation(),
                  );
                },
              ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
