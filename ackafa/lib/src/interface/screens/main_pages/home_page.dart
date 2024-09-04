import 'package:ackaf/src/interface/screens/main_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/menuPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/notificationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

List<Map<String, dynamic>> banner = [
  {
    "image": "assets/homegirl.png",
    "colors": [
      Color.fromARGB(41, 249, 180, 6),
      Color.fromARGB(113, 249, 180, 6)
    ]
  },
  {
    "image": "assets/man.png",
    "colors": [Color(0xFFC0F6C6), Color(0xFF739D72)]
  }
];

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45.0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/icons/ackaf_logo.png',
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search promotions',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 214, 211, 211)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 217, 212, 212)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                color: Colors.transparent,
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: banner.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: _buildCards(MediaQuery.sizeOf(context).width,
                          banner[index]["image"], banner[index]["colors"]),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 0, left: 16, right: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, // Set the background color to white
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: const Color.fromARGB(
                        255, 225, 231, 236), // Set the border color to blue
                    width: 2.0, // Adjust the width as needed
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/membership_logo.svg', // Ensure this path is correct
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KSSIA Membership',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(
                                  0xFF004797), // Set the font color to blue
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Lorem ipsum dolor sit amet consectetur. Eget velit sagittis sapien in vitae ut. Lorem cursus sed nunc diam ullamcorper elit.',
                            style: TextStyle(
                              color: Color.fromRGBO(
                                  0, 0, 0, 1), // Set the font color to blue
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 0, left: 16, right: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(41, 249, 180, 6),
                      Color.fromARGB(113, 249, 180, 6)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/posterside_logo.svg', // Ensure this path is correct
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    const Text('Poster',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    const SizedBox(height: 8),
                    const Text(
                        'Lorem ipsum dolor sit amet consectetur. Eget velit sagittis sapien in vitae ut. Lorem cursus sed nunc diam ullamcorper elit.'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Know More',
                            style: TextStyle(
                              color: Color(0xFF040F4F), // Change the color here
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color:
                                Color(0xFF040F4F), // Change the icon color here
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 0, left: 16, right: 16),
              child: const Text('Video title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 0, left: 16, right: 16),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors
                      .transparent, // Make background transparent to show the image
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/icons/homepage_youtube.png', // Add your image here
                    width: double.infinity,
                    height: 200, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCards(double width, String image, List<Color> colors) {
  return Container(
    width: width / 1.20,
    child: Stack(
      clipBehavior: Clip.none, // This allows overflow
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 100),
                  SizedBox(width: 40),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              'Lorem ipsum dolor sit amet',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                'Lorem ipsum dolor sit amet',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: -10,
          bottom: -10, // Make this value more negative to move the image up
          child: SizedBox(
            width: 240, // Adjust the width of the image
            height: 240, // Adjust the height of the image
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}
