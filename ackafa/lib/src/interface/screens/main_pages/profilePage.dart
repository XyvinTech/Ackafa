import 'package:ackaf/src/interface/common/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:ackaf/src/interface/screens/profile/card.dart';
import 'package:ackaf/src/interface/screens/profile/profilePreview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart'; // Import the XCard widget

class ProfilePage extends StatelessWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(40.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 237, 231, 231)),
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 182, 181, 181)
                                  .withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: const Offset(.5, .5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFFF2F2F2),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                ProfilePreview(
                                              user: user,
                                            ),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    user.image != null && user.image != ''
                                        ? CircleAvatar( 
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                              user.image ?? '',
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/icons/dummy_person.png'),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${user.name!.first!} ${user.name?.middle ?? ''} ${user.name!.last!}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            if (user.company != null)
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                  child: user.company?.logo !=
                                                              null &&
                                                          user.company?.logo !=
                                                              ''
                                                      ? Image.network(
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Image.asset(
                                                                'assets/icons/dummy_company.png');
                                                          },
                                                          user.company!.logo!,
                                                          height: 33,
                                                          width: 40,
                                                          fit: BoxFit.contain,
                                                        )
                                                      : SizedBox())
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (user.company?.designation !=
                                                null)
                                              Text(
                                                user.company?.designation ?? '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 42, 41, 41),
                                                ),
                                              ),
                                            if (user.company?.name != null)
                                              Text(
                                                user.company?.name ?? '',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 35, right: 30, top: 25, bottom: 35),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 237, 231, 231)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: const Offset(.5, .5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.grey),
                                const SizedBox(width: 10),
                                Text(user.phone!),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.email, color: Colors.grey),
                                const SizedBox(width: 10),
                                Text(user.email!),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (user.address != null && user.address != '')
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.grey),
                                  const SizedBox(width: 10),
                                  if (user.address != null)
                                    Expanded(
                                      child: Text(
                                        user.address ?? '',
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 237, 231, 231)),
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: const Offset(.5, .5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Member ID: ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: user.memberId,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Share.share(
                                  'https://admin.akcafconnect.com/user/${user.id}');
                            },
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Color(0xFFE30613),
                                borderRadius: BorderRadius.circular(
                                    50), // Apply circular border to the outer container
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0xFFE30613),
                                  ),
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileCard(
                                    user: user,
                                  ), // Navigate to CardPage
                                ),
                              );
                            },
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    50), // Apply circular border to the outer container
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.qr_code,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
