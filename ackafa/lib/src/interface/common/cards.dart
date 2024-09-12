import 'package:ackaf/src/interface/common/components/svg_icon.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:ackaf/src/data/models/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AwardCard extends StatelessWidget {
  final VoidCallback? onRemove;

  final Award award;

  const AwardCard({required this.onRemove, required this.award, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: SizedBox(
        height: 150.0, // Set the desired fixed height for the card
        width: double.infinity, // Ensure the card width fits the screen
        child: Column(
          mainAxisSize:
              MainAxisSize.max, // Make the column take the full height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Upper part: Image fitted to the card
                Container(
                  height: 100.0, // Adjusted height to fit within the 150px card
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          award.image!), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
                if (onRemove != null)
                  Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            onRemove!();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 22,
                          ),
                        )),
                  ),
              ],
            ),
            // Lower part: Text
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFF2F2F2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              award.name ?? '',
                              style: const TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          award.authority ?? '',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
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

class CertificateCard extends StatelessWidget {
  final VoidCallback? onRemove;

  final Link certificate;

  const CertificateCard(
      {required this.onRemove, super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color.fromARGB(255, 201, 198, 198)),
        ),
        height: 200.0, // Set the desired fixed height for the card
        width: double.infinity, // Ensure the card width fits the screen
        child: Column(
          mainAxisSize:
              MainAxisSize.max, // Make the column take the full height
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150.0, // Adjusted height to fit within the 150px card
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                image: DecorationImage(
                  image: NetworkImage(
                      certificate.link!), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: onRemove != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              certificate.name!,
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                                onPressed: () => onRemove!(),
                                icon: Icon(Icons.close))
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              certificate.name!,
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w600),
                            ),
                          ],
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

// class DropDownMenu extends StatelessWidget {
//   final VoidCallback onRemove;

//   const DropDownMenu({super.key, required this.onRemove});

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2(
//         customButton: const Icon(
//           Icons.more_vert,
//           color: Colors.black,
//           size: 22,
//         ),
//         items: [
//           const DropdownMenuItem<String>(
//             value: 'remove',
//             child: Text(
//               'Remove',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.red,
//               ),
//             ),
//           ),
//         ],
//         onChanged: (value) {
//           if (value == 'remove') {
//             onRemove();
//           }
//         },
//         dropdownStyleData: DropdownStyleData(
//           width: 160,
//           padding: const EdgeInsets.symmetric(vertical: 6),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         menuItemStyleData: const MenuItemStyleData(
//           height: 48,
//           padding: EdgeInsets.symmetric(horizontal: 16),
//         ),
//       ),
//     );
//   }
// }
