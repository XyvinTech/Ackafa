import 'package:ackaf/src/interface/common/shimmer.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_details_page.dart';
import 'package:ackaf/src/interface/screens/menu/hall_booking.dart';
import 'package:ackaf/src/interface/screens/menu/my_subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPage.dart';
// import 'package:ackaf/src/interface/screens/menu/my_product.dart';
// import 'package:ackaf/src/interface/screens/menu/my_reviews.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../menu/requestNFC.dart';
// import '../menu/myrequirementsPage.dart';
import '../menu/terms_and_conditions.dart';
import '../menu/privacy.dart';
import '../menu/about.dart';
// import '../menu/my_subscription.dart';
import '../menu/my_events.dart';
import '../menu/my_post.dart';
import 'package:animate_do/animate_do.dart';

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        title: Container(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            children: [
              Icon(
                Icons.help,
                color: Colors.blue,
                size: 60,
              ),
              SizedBox(height: 10),
              Text(
                'Delete Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('No',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Yes, Delete',
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                      onPressed: () {
                        // Add your delete account logic here
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        title: Container(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            children: [
              Icon(
                Icons.help,
                color: Colors.blue,
                size: 60,
              ),
              SizedBox(height: 10),
              Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('No',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Yes',
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                      onPressed: () async {
                        LoggedIn = false;
                        final SharedPreferences preferences =
                            await SharedPreferences.getInstance();

                        preferences.setString('token', '');
                        preferences.setString('id', '');

                        // Clear the entire stack and push the login screen
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login_screen',
                          (Route<dynamic> route) =>
                              false, // This removes all the previous routes
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: asyncUser.when(
              loading: () => MenuPageShimmer(),
              error: (error, stackTrace) {
                // Handle error state
                return Center(
                  child: Text('$error'),
                );
              },
              data: (user) {
                print(user);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile and Edit Section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Profile Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.network(
                                user.image ?? '',
                                height: 70,
                                width: 75,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/icons/dummy_person_small.png');
                                },
                              ),
                            ),
                            const SizedBox(width: 16),

                            // User Info (Name and Phone)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.fullName ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Truncate text if too long
                                  ),
                                  Text(
                                    user.phone!,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                    overflow: TextOverflow
                                        .ellipsis, // Truncate phone number if necessary
                                  ),
                                ],
                              ),
                            ),

                            // "Edit" Button
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        const DetailsPage(),
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    transitionsBuilder: (_, a, __, c) =>
                                        FadeTransition(opacity: a, child: c),
                                  ),
                                );
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Account Section Label

                      const SizedBox(height: 13),

                      Container(
                        height: 50,
                        width: double.infinity,
                        color: const Color(0xFFF2F2F2),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              Text(
                                'ACCOUNT',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      _buildListTile(
                        context,
                        Icons.credit_card,
                        'Request NFC',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestNFCPage()),
                          );
                        },
                      ),
if(user.phone!='+919645398555')
                      const Divider(),
if(user.phone!='+919645398555')
                      _buildListTile(
                        context,
                        Icons.loyalty_outlined,
                        'My Subscriptions',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MySubscriptionPage()),
                          );
                        },
                      ),
                      if (user.role != 'member') const Divider(),
                      if (user.role != 'member')
                        _buildListTile(
                          context,
                          Icons.edit_calendar_outlined,
                          'Hall Booking',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HallBookingPage()),
                            );
                          },
                        ),
                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.event,
                        'My Events',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyEventsPage()),
                          );
                        },
                      ),
                      const Divider(),

                      _buildListTile(
                        context,
                        Icons.notifications_none,
                        'My Posts',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyPostsPage()),
                          );
                        },
                      ),

                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.info_outline,
                        'About us',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()),
                          );
                        },
                      ),
                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.article_outlined,
                        'Privacy policy',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicyPage()),
                          );
                        },
                      ),
                      const Divider(),
                      _buildListTile(
                        context,
                        Icons.description_outlined,
                        'Terms & condition',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditionsPage()),
                          );
                        },
                      ),

                      // Spacing before Logout and Delete
                      Container(color: const Color(0xFFF2F2F2), height: 15),

                      // Logout and Delete Account
                      _buildListTile(
                        context,
                        Icons.logout,
                        'Logout',
                        textColor: Colors.black,
                        onTap: () => showLogoutDialog(context),
                      ),
                      Container(color: const Color(0xFFF2F2F2), height: 15),

                      // Column(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(),
                      //       child: _buildListTile(
                      //           context, Icons.delete, 'Delete account',
                      //           onTap: () => showDeleteAccountDialog(context),
                      //           IconColor: Colors.red),
                      //     ),
                      //   ],
                      // ),

                      Container(
                        color: const Color(0xFFF2F2F2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeInDown(
                              child: const Center(
                                child: Text(
                                  'Version 1.0',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FadeInUp(
                              delay: const Duration(milliseconds: 300),
                              child: GestureDetector(
                                onTap: () {
                                  _launchURL('https://www.skybertech.ae');
                                },
                                child: const Text(
                                  'Powered By SkyberTech',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FadeInUp(
                              delay: const Duration(milliseconds: 600),
                              child: GestureDetector(
                                onTap: () {
                                  _launchURL('https://www.xyvin.com');
                                },
                                child: const Text(
                                  'Developed By Xyvin',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(color: const Color(0xFFF2F2F2), height: 20),
                    ],
                  ),
                );
              },
            ));
      },
    );
  }

  void _launchURL(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print(e);
    }
  }

  ListTile _buildListTile(BuildContext context, IconData icon, String title,
      {Color textColor = const Color.fromARGB(255, 0, 0, 0),
      Function()? onTap,
      Color IconColor = const Color(0xFF585858)}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: IconColor),
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: SvgPicture.asset(
        'assets/icons/polygon.svg',
        height: 16,
        width: 16,
        color: const Color(0xFFC4C4C4),
      ),
      onTap: onTap ??
          () {
            // Handle list item tap
          },
    );
  }
}
