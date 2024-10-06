import 'dart:developer';

import 'package:ackaf/src/data/models/chat_model.dart';
import 'package:ackaf/src/data/models/group_info.dart';
import 'package:ackaf/src/data/services/api_routes/group_api.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupInfoPage extends StatelessWidget {
  const GroupInfoPage(
      {super.key, required this.groupName, required this.groupId});
  final String groupName;
  final String groupId;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncGroupInfo = ref.watch(fetchGroupInfoProvider(id: groupId));
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(
                  65.0), // Adjust the size to fit the border and content
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white, // AppBar background color
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 231, 226, 226), // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                ),
                child: AppBar(
                  toolbarHeight: 45.0,
                  scrolledUnderElevation: 0,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leadingWidth: 100,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        'assets/icons/ackaf_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationPage()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MenuPage()), // Navigate to MenuPage
                        );
                      },
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.arrow_back,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(groupName)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: asyncGroupInfo.when(
              data: (groupInfo) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGroupInfoSection(groupInfo: groupInfo),
                    Divider(
                      color: const Color.fromARGB(255, 231, 225, 225),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            'Members  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${groupInfo.memberCount}',
                            style: TextStyle(color: Colors.red, fontSize: 25),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: const Color.fromARGB(255, 231, 225, 225),
                    ),
                    _buildMemberListSection(groupInfo.participantsData ?? [])
                  ],
                );
              },
              loading: () => Center(child: LoadingAnimation()),
              error: (error, stackTrace) {
                log('$error');
                return const Center(
                  child: Text('No Members'),
                );
              },
            ));
      },
    );
  }

  Widget _buildGroupInfoSection({required GroupInfoModel groupInfo}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CircleAvatar(
          //   backgroundImage: AssetImage('assets/group_image.png'),
          //   radius: 40,
          // ),
          SizedBox(height: 16),
          const Text(
            'About the group',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            groupInfo.groupInfo ?? '',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberListSection(List<GroupParticipantModel> members) {
    return Expanded(
      child: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Column(children: [
            _buildMemberTile(member),
            const Divider(
              color: const Color.fromARGB(255, 231, 225, 225),
            )
          ]);
        },
      ),
    );
  }

  Widget _buildMemberTile(GroupParticipantModel member) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
      child: ListTile(
        leading: Image.asset(
          'assets/icons/dummy_person_small.png',
          scale: .7,
        ),

        // CircleAvatar(
        //   backgroundImage: AssetImage(member.imagePath),
        //   radius: 25,
        // ),
        title: Text(member.name ?? '',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              member.college ?? '',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 103, 100, 100)),
            ),
            Text(
              member.batch.toString(),
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        // trailing: member.isAdmin
        //     ? ElevatedButton(
        //         onPressed: () {},
        //         style: ElevatedButton.styleFrom(
        //           primary: Colors.red,
        //           padding: EdgeInsets.symmetric(horizontal: 12),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(20),
        //           ),
        //         ),
        //         child: Text('Group admin'),
        //       )
        //     : null,
      ),
    );
  }

  Widget _buildExitGroupButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.exit_to_app, color: Colors.red),
          label: const Text(
            'Exit group',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
