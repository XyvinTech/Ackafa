import 'dart:io';

class AppVersionResponse {
  final int version;
  final bool force;
  final String applink;
  final String updateMessage;

  AppVersionResponse({
    required this.version,
    required this.force,
    required this.applink,
    required this.updateMessage,
  });

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) {
    final customer = json['data']['application']['customer'];
    final platform = customer[Platform.isIOS ? 'ios' : 'android'];
    return AppVersionResponse(
      version: platform['version'],
      force: platform['force'],
      applink: platform['applink'],
      updateMessage: platform['updateMessage'],
    );
  }
}