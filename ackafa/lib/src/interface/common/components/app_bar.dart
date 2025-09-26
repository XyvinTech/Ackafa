// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class App_bar extends StatelessWidget implements PreferredSizeWidget {

//   const App_bar({Key? key, }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading:SvgPicture.asset(
//   'assets/icons/ackafLogo.svg',
//   semanticsLabel: 'ackaf Logo'
// ),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.notifications), // Replace with your notification icon
//           onPressed: () {
//             // Add your notification icon's onPressed functionality here
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.menu), // Replace with your hamburger icon
//           onPressed: () {
//             // Add your hamburger icon's onPressed functionality here
//           },
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/notifires/approval_notifier.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/api_routes/notification_api.dart';
import 'package:ackaf/src/interface/screens/main_pages/approvalPages/approval_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool iselevationNeeded;
  final bool isThreeDashNeeded;

  
  final bool showBackButton;
  const CustomAppBar(
      {Key? key, this.iselevationNeeded = false, this.isThreeDashNeeded = false,this.showBackButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: iselevationNeeded ? Offset(0, 2) : Offset(0, 0),
            blurRadius: iselevationNeeded ? 4 : 0,
          ),
        ],
      ),
      child: AppBar(
        toolbarHeight: 50,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/icons/ackaf_logo.png', // Hardcoded logo path
              fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            if (showBackButton) {
              Navigator.pop(context); // Go back
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuPage()),
              );
            }
          },
          child: Icon(
            showBackButton ? Icons.arrow_back_ios : Icons.menu,
            size: 20,
          ),
        ),

        
        actions: [
          // Consumer(
          //   builder: (context, ref, child) {
          //     final asyncUser = ref.watch(userProvider);
          //     final nonApprovedUsers = ref.watch(approvalNotifierProvider);
          //     return asyncUser.when(
          //       data: (user) {
          //         return Stack(
          //           children: <Widget>[
          //             if (user.role != 'member')
          //               IconButton(
          //                   iconSize: 17,
          //                   onPressed: () {
          //                     Navigator.push(
          //                       context,
          //                       PageRouteBuilder(
          //                         pageBuilder: (context, animation,
          //                                 secondaryAnimation) =>
          //                             ApprovalPage(),
          //                         transitionsBuilder: (context, animation,
          //                             secondaryAnimation, child) {
          //                           const begin = Offset(
          //                               1.0, 0.0); // Slide from right to left
          //                           const end = Offset.zero;
          //                           const curve =
          //                               Curves.fastEaseInToSlowEaseOut;

          //                           var tween = Tween(begin: begin, end: end)
          //                               .chain(CurveTween(curve: curve));
          //                           var offsetAnimation =
          //                               animation.drive(tween);

          //                           return SlideTransition(
          //                             position: offsetAnimation,
          //                             child: child,
          //                           );
          //                         },
          //                       ),
          //                     );
          //                   },
          //                   icon: Icon(
          //                     FontAwesomeIcons.userGroup,
          //                     color: Colors.grey,
          //                   )),
          //             if (nonApprovedUsers.isNotEmpty && user.role != 'member')
          //               Positioned(
          //                 right: 4,
          //                 bottom: 2,
          //                 child: Container(
          //                   padding: EdgeInsets.all(4),
          //                   decoration: BoxDecoration(
          //                     color: Colors.red,
          //                     shape: BoxShape.circle,
          //                   ),
          //                   child: Text(
          //                     '${nonApprovedUsers.length}',
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 12,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //           ],
          //         );
          //       },
          //       loading: () => Center(
          //         child: IconButton(
          //             iconSize: 17,
          //             onPressed: () {},
          //             icon: Icon(
          //               FontAwesomeIcons.userGroup,
          //               color: Colors.grey,
          //             )),
          //       ),
          //       error: (error, stackTrace) {
          //         return SizedBox();
          //       },
          //     );
          //   },
          // ),
          Consumer(
            builder: (context, ref, child) {
              final asyncNotifications = ref.watch(fetchNotificationsProvider);
              return asyncNotifications.when(
                data: (notifications) {
                  bool userExists = false;
                  notifications.map(
                    (notification) {
                      userExists = notification.users?.any((user) {
                            return user.user == id;
                          }) ??
                          false;
                    },
                  );
                  return IconButton(
                    icon: userExists
                        ? Icon(
                            Icons.notification_add_outlined,
                            color: Colors.red,
                          )
                        : Icon(Icons.notifications_none_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationPage()),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: Icon(Icons.notifications_none_outlined),
                ),
                error: (error, stackTrace) {
                  return Center(
                    child: Text(''),
                  );
                },
              );
            },
          ),
          // if (isThreeDashNeeded)
          //   IconButton(
          //     icon: const Icon(Icons.menu),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => MenuPage()), // Hardcoded action
          //       );
          //     },
          //   ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45.0);
}
