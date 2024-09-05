import 'package:ackaf/src/data/notifires/people_notifier.dart';
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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      ref.read(peopleNotifierProvider.notifier).fetchMoreUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(peopleNotifierProvider);
    final isLoading = ref.read(peopleNotifierProvider.notifier).isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loader when no data
          : ListView.builder(
              controller: _scrollController,
              itemCount: users.length + 1, // Add 1 for the loading indicator
              itemBuilder: (context, index) {
                if (index == users.length) {
                  return isLoading
                      ? Center(child: CircularProgressIndicator()) // Show loading when fetching more users
                      : SizedBox.shrink(); // Hide when done
                }

                final user = users[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePreview(
                          user: user,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipOval(
                        child: Image.network(
                          user.image ?? 'https://placehold.co/600x400/png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://placehold.co/600x400/png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(user.name?.first ?? 'No Name'),
                    subtitle: user.company?.designation != null
                        ? Text(user.company!.designation!)
                        : null,
                    trailing: IconButton(
                      icon: Icon(Icons.chat),
                      onPressed: () {
                        // Handle chat functionality
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}