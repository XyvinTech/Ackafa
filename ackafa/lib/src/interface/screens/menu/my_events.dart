import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.whatsapp),
            onPressed: () {
              // WhatsApp action
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: ListView(
        children: [
          eventCard(context),
        ],
      ),
    );
  }

  Widget eventCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                'https://via.placeholder.com/400x200',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  color: const Color(0xFFA9F3C7),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: const Text('LIVE', style: TextStyle(color: Color(0xFF0F7036), fontSize: 14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOPIC',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3F0A9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: Color(0xFF700F0F)),
                          const SizedBox(width: 5),
                          const Text(
                            '02 Jan 2023',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF700F0F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFAED0E9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 20, color: Color(0xFF0E1877)),
                          const SizedBox(width: 5),
                          const Text(
                            '09:00 PM',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0E1877),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lorem ipsum dolor sit amet consectetur.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Lorem ipsum dolor sit amet consectetur. Eget velit sagittis sapien in vitae ut. Lorem cursus sed nunc diam ullamcorper elit.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Join event action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004797),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // Adjust the value to make the edge less circular
                      ),
                      minimumSize: const Size(150, 40), // Adjust the width of the button
                    ),
                    child: const Text('JOIN', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
