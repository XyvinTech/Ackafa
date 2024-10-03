import 'dart:convert';
import 'dart:developer';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/appversion_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_upgrade_version/flutter_upgrade_version.dart';

Future<void> checkAppVersion(context) async {
  final response = await http
      .get(Uri.parse('http://akcafconnect.com/api/v1/user/app-version'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final appVersionResponse = AppVersionResponse.fromJson(jsonResponse);
    isPaymentEnabled = appVersionResponse.isPaymentEnabled ?? true;

    await checkForUpdate(appVersionResponse, context);
  } else {
    throw Exception('Failed to load app version');
  }
}

Future<void> checkForUpdate(AppVersionResponse response, context) async {
  PackageInfo packageInfo = await PackageManager.getPackageInfo();
  final currentVersion = int.parse(packageInfo.version.split('.').join());
  log('current version:${currentVersion.toString()}');
  log('new version:${response.version.toString()}');
  if (currentVersion < response.version && response.force) {
    showUpdateDialog(response, context);
  }
}

void showUpdateDialog(AppVersionResponse response, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      onPopInvokedWithResult: (didPop, res) {
        SystemNavigator.pop();
      },
      child: AlertDialog(
        title: Text('Update Required'),
        content: Text(response.updateMessage),
        actions: [
          TextButton(
            onPressed: () {
              // Redirect to app store
              _launchURL(response.applink);
            },
            child: Text('Update Now'),
          ),
        ],
      ),
    ),
  );
}

void _launchURL(String url) async {
  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    print(e);
  }
}
