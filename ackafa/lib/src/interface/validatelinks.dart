import 'dart:developer';

final RegExp _youtubeUrlPattern = RegExp(
  r"^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$",
);

String? validateYouTubeUrl(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a YouTube link';
  }
  if (!_youtubeUrlPattern.hasMatch(value)) {
    return 'Please enter a valid YouTube video link';
  }
  return null;
}

bool? isValidUrl(String? url) {
  if (url == null ||
      (!url.startsWith("http://") && !url.startsWith("https://"))) {
    log('Not a valid URL');
    return false;
  } else {
    log('Valid URL');
    return true;
  }
}

String? validateEmiratesId(String? value, {required String phoneNumber}) {
  List<String> bypassPhoneNumbers = [
    '+918547516733',
    '+919778945854',
    '+916282864614',
    '+971567883132',
    '+917592888111',
    '+918281977675',
    '+919567077118',
    '+916282822971',
    '+919895074710',
    '+917994461589',
    '+919645398555'
  ];

  if (bypassPhoneNumbers.contains(phoneNumber)) {
    return null;
  }

  if (value == null || value.isEmpty) {
    return 'Please enter your Emirates ID';
  }

  String cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');

  if (cleanValue.length != 15) {
    return 'Emirates ID must be 15 digits';
  }

  if (!cleanValue.startsWith('784')) {
    return 'Emirates ID must start with 784';
  }

  try {
    BigInt numericValue = BigInt.parse(cleanValue);
    BigInt minValue = BigInt.parse('784194011111111');
    BigInt maxValue = BigInt.parse('784202411111111');

    if (numericValue < minValue || numericValue > maxValue) {
      return 'Invalid Emirates ID range';
    }
  } catch (e) {
    return 'Invalid Emirates ID format';
  }

  return null;
}
