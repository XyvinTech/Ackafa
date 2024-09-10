import 'package:http/http.dart'as http;


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

Future<bool> isValidUrl(String url) async {
  try {
    // Make sure the URL has a proper scheme like "http" or "https"
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      return false;
    }

    // Send a GET request to the URL
    final response = await http.get(Uri.parse(url));

    // A valid response typically returns status codes in the range of 200–299
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    // Catch exceptions like network errors or invalid URLs
    return false;
  }
}