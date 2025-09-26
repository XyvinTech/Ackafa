import 'dart:developer';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/main_page.dart';

import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCompletionScreen extends StatelessWidget {
  ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return asyncUser.when(
          data: (user) {
            String percentageString = user.profileCompletion ?? '0%';
            int profileCompletion =
                int.parse(percentageString.replaceAll('%', ''));
            if (profileCompletion < 70) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      //  Circle background with image
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 210,
                              height: 210,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFFEEF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 180,
                              height: 180,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF8EF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Image.asset(
                              'assets/success.png',
                              scale: 0.7,
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                      
                      const Text(
                        "Let's Get Started,\nComplete your profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 118, 121, 124),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Get ready to dive in! Just finish\n setting up your profile.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 118, 121, 124),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 25, top: 10),
                        child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: customButton(
                                label: 'Next',
                                onPressed: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  preferences.setString('id', user.id ?? '');
                                 Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    settings: RouteSettings(
                                        name: 'ProfileCompletion'),
                                    builder: (context) => const DetailsPage()));
                                },
                                fontSize: 16)),
                      ),
                      TextButton(
                        onPressed: () async {
                          log('PROFFFFFFFFFFFFFFFIIIIIIILLLLLLLLE COMPLEEEEEEEEEEEEETIONNNNNN${user.id}');
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MainPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text('Skip',
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                      )
                    ],
                  ),
                ),
              );
            }
             else {
              return MainPage();
            }
          },
          loading: () => Scaffold(
            body: Center(child: LoadingAnimation())),
          error: (error, stackTrace) {
            // Handle error state
            return Center(
              child: Text('Something went wrong'),
            );
          },
        );
      },
    );
  }
}
