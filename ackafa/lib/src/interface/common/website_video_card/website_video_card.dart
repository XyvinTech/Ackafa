import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/interface/common/components/svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Padding customWebsiteCard({Link? website, VoidCallback? onRemove}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 20,
      left: 15,
      right: 15,
    ),
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
                child: Icon(
                  Icons.language,
                  color: Color(0xFFE30613),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                '${website!.name}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1, // Optional: to limit to one line
                style: TextStyle(fontSize: 16), // Adjust style as needed
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onRemove!(),
            child: Padding(
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
                  child: Icon(
                    Icons.remove,
                    color: Color(0xFFE30613),
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

Padding customVideoCard({Link? video, VoidCallback? onRemove}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 20,
      left: 15,
      right: 15,
    ),
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
                child: Icon(
                  FontAwesomeIcons.youtube,
                  color: Color(0xFFE30613),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                '${video!.name}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1, // Optional: to limit to one line
                style: TextStyle(fontSize: 16), // Adjust style as needed
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onRemove!(),
            child: Padding(
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
                  child: Icon(
                    Icons.remove,
                    color: Color(0xFFE30613),
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
