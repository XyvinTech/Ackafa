// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'dart:io'; // For platform detection

// /// [DynamicLinkService]
// class DynamicLinkService {
//   static final DynamicLinkService _singleton = DynamicLinkService._internal();
//   DynamicLinkService._internal();
//   static DynamicLinkService get instance => _singleton;

//   // Create dynamic link for a specific page
//   Future<Uri> createDynamicLink({required String page}) async {
//     Uri link;


//       link = Uri.parse("https://akacf.page.link/$page");


//     // Build dynamic link parameters
//     final dynamicLinkParams = DynamicLinkParameters(
//       link: link, // Page-specific deep link
//       uriPrefix: "https://akacf.page.link",
//       androidParameters: const AndroidParameters(
//         packageName: "com.skybertech.ackaf",
//       ),
//       iosParameters: const IOSParameters(
//         bundleId: "com.skybertech.akcaf",
//         appStoreId: "6670522108",
//       ),
//     );

//     // Create the short dynamic link
//     final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
//     debugPrint("Dynamic Link Created: ${dynamicLink.shortUrl}");

//     return dynamicLink.shortUrl;
//   }
// }


