import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/services/api_routes/events_api.dart';
import 'package:kssia/src/data/services/api_routes/news_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/event_news/event.dart';
import 'package:kssia/src/interface/screens/event_news/news.dart';
import 'package:kssia/src/interface/screens/main_pages/menuPage.dart';
import 'package:kssia/src/interface/screens/main_pages/notificationPage.dart';


class Event_News_Page extends StatefulWidget {
  @override
  _Event_News_PageState createState() => _Event_News_PageState();
}

class _Event_News_PageState extends State<Event_News_Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final newsAsyncValue = ref.watch(fetchNewsProvider(token));
        final eventsAsyncValue = ref.watch(fetchEventsProvider(token));

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 60.0,
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
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    size: 21,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 21,
                  ),
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
                preferredSize: Size.fromHeight(20),
                child: Container(
                  margin: EdgeInsets.only(
                      top: 0), // Adjust this value to reduce space
                  child: const SizedBox(
                    height: 40,
                    child: TabBar(
                      isScrollable: false, // Disable scroll to center the tabs
                      indicatorColor:
                          Color(0xFFE30613), // Set to AppPalette.kPrimaryColor
                      indicatorWeight: 3.0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Color(0xFFE30613),
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(text: "NEWS"),
                        Tab(text: "EVENTS"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: newsAsyncValue.when(
                    data: (news) => eventsAsyncValue.when(
                      data: (events) {
                        return TabBarView(
                          children: [
                            NewsPage(news: news),
                            EventPage(events: events),
                          ],
                        );
                      },
                      loading: () => Center(child: LoadingAnimation()),
                      error: (error, stack) => Center(
                        child: Text('Error loading events: $error'),
                      ),
                    ),
                    loading: () => Center(child: LoadingAnimation()),
                    error: (error, stack) => Center(
                      child: Text('Error loading news: $error'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
