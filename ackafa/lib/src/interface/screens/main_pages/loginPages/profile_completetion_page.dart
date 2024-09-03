
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/screens/main_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_details_page.dart';
import 'package:flutter/material.dart';

class ProfileCompletionScreen extends StatelessWidget {

  ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace SvgPicture.asset with any image you are using
            Image.asset('assets/letsgetstarted.png', width: 150),

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
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: customButton(
                      label: 'Next', onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsPage()));
                      }, fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainPage()));
              },
              child: const Text('Skip',
                  style: TextStyle(color: Colors.black, fontSize: 15)),
            )
          ],
        ),
      ),
    );
  }
}

