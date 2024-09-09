import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/interface/common/components/svg_icon.dart';
import 'package:flutter/material.dart';

class ProfilePreviewLink extends StatelessWidget {

  final Link? website;

  ProfilePreviewLink({
    Key? key,
   
    this.website,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF2F2F2),
        ),
        child: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Align(
                alignment: Alignment.topCenter,
                widthFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  width: 42,
                  height: 42,
                  child:  const Icon(Icons.web),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
             website!.link!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
