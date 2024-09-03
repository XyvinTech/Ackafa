import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/interface/screens/profile/profilePreview.dart';

class MembersPage extends StatelessWidget {
  final List<UserModel> users;
  const MembersPage({super.key, required this.users});

  // final List<Member> members = [
  //   Member('Alice', 'Software Engineer', 'https://example.com/avatar1.png'),
  //   Member('Bob', 'Product Manager', 'https://example.com/avatar2.png'),
  //   Member('Charlie', 'Designer', 'https://example.com/avatar3.png'),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePreview(
                        user: users[index],
                      )));
            },
            child: ListTile(
              leading: SizedBox(
                height: 40,
                width: 40,
                child: ClipOval(
                  child: Image.network(
                    users[index].image ??
                        'https://placehold.co/600x400/png',
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
              title: Text('${users[index].name!.first}'),
              subtitle: Text(users[index].company!.designation!),
              trailing: IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
