import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';

class TestApi extends StatelessWidget {
  const TestApi({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return Scaffold(
            body: asyncUser.when(
          data: (user) {
            print(user);
            return Center(
              child: Text('Sucesss'),
            );
          },
          loading: () => Center(child: LoadingAnimation()),
          error: (error, stackTrace) {
            print('StackTrace: $stackTrace');
            print(error);
            // Handle error state
            return Center(
              child: Text('Error loading promotions: $error'),
            );
          },
        ));
      },
    );
  }
}
