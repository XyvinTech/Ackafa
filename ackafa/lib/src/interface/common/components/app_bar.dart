// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class App_bar extends StatelessWidget implements PreferredSizeWidget {

//   const App_bar({Key? key, }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading:SvgPicture.asset(
//   'assets/icons/kssiaLogo.svg',
//   semanticsLabel: 'Kssia Logo'
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

import 'package:flutter/material.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';

class App_bar extends StatelessWidget implements PreferredSizeWidget {
  const App_bar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 40.0,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      leadingWidth: 100,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Image.asset(
            'assets/icons/kssiaLogo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuPage()), // Navigate to MenuPage
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
