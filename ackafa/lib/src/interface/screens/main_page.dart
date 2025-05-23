import 'dart:developer';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/services/api_routes/chat_api.dart';
import 'package:ackaf/src/interface/screens/event_news/news.dart';
import 'package:ackaf/src/interface/screens/main_pages/feed_view.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/paymentpage.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/subcription_expired_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_inactive_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/main_pages/event_news_page.dart';

import 'package:ackaf/src/interface/screens/main_pages/home_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/people_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IconResolver extends StatelessWidget {
  final String iconPath;
  final Color color;
  final double height;
  final double width;

  const IconResolver({
    Key? key,
    required this.iconPath,
    required this.color,
    this.height = 24,
    this.width = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (iconPath.startsWith('http') || iconPath.startsWith('https')) {
      return Image.network(
        iconPath,
        color: color,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      );
    } else {
      return SvgPicture.asset(
        iconPath,
        color: color,
        height: height,
        width: width,
      );
    }
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  late final webSocketClient;

  @override
  void initState() {
    super.initState();
    ref.read(userProvider.notifier).refreshUser();
    webSocketClient = ref.read(socketIoClientProvider);
    webSocketClient.connect(id, ref);
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      ref.read(currentNewsIndexProvider.notifier).state = 0;
      _selectedIndex = index;
    });
  }

  List<String> _inactiveIcons = [];
  List<String> _activeIcons = [];
  Future<void> _initialize({required UserModel user}) async {
    _widgetOptions = <Widget>[
      // HomePage(),
      // FeedPage(),
      HomePage(
        user: user,
      ),
      FeedView(),
      ProfilePage(user: user),
      NewsPage(),
      PeoplePage(),
      // Event_News_Page(),
      // PeoplePage(),
    ];
    _inactiveIcons = [
      'assets/icons/home_inactive.svg',
      'assets/icons/feed_inactive.svg',
      user.image ?? '',
      'assets/icons/inactive_news.svg',
      'assets/icons/inactive_chat.svg',
    ];
    _activeIcons = [
      'assets/icons/home_active.svg',
      'assets/icons/feed_active.svg',
      user.image ?? '',
      'assets/icons/active_news.svg',
      'assets/icons/active_chat.svg',
    ];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', user.id!);
    id = preferences.getString('id') ?? '';
    log('main page user id:$id');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final asyncUser = ref.watch(userProvider);
      return asyncUser.when(
        loading: () => Scaffold(body: Center(child: LoadingAnimation())),
        error: (error, stackTrace) {
          return LoginPage();
        },
        data: (user) {
          switch (user.status?.toLowerCase()??'inactive') {
            case 'inactive':
                        return UserInactivePage();
            case 'awaiting_payment':
                        return PaymentConfirmationPage();
            case 'subscription_expired':
                        return SubcriptionExpiredPage();
case 'active':
  log(user.image.toString());
          _initialize(user: user);
          return Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: List.generate(5, (index) {
                return BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: index == 2 // Assuming profile is the third item
                      ? user.image != null && user.image != ''
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                user.image ?? '',
                              ),
                              radius: 15,
                            )
                          : Image.asset(
                              'assets/icons/dummy_person_small.png',
                              scale: 1.5,
                            )
                      : IconResolver(
                          iconPath: _inactiveIcons[index],
                          color: _selectedIndex == index
                              ? Colors.blue
                              : Colors.grey,
                        ),
                  activeIcon: index == 2
                      ? user.image != null && user.image != ''
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                user.image ?? '',
                              ),
                              radius: 15,
                            )
                          : Image.asset(
                              'assets/icons/dummy_person_small.png',
                              scale: 1.5,
                            )
                      : IconResolver(
                          iconPath: _activeIcons[index],
                          color: Color(0xFFE30613),
                        ),
                  label: ['Home', 'Feed', 'Profile', 'News', 'Chats'][index],
                );
              }),
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xFFE30613),
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
              showUnselectedLabels: true,
            ),
          );
            default:
                         return UserInactivePage();

          }
        
        },
      );
    });
  }
}
