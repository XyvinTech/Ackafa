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
