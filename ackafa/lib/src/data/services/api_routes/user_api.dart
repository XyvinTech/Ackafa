import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:ackaf/src/data/globals.dart';

import 'package:ackaf/src/data/models/user_model.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_api.g.dart';

class ApiRoutes {
  Future<bool> registerUser(
      {required String token,
      required String? profileUrl,
      required String? name,
      required String? emiratesID,
      required String? emailId,
      required String? college,
      required String? batch,
      required context}) async {
    final url = Uri.parse('$baseUrl/user/update');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: jsonEncode({
        "fullName": name,
        if (profileUrl != null && profileUrl != '') "image": profileUrl,
        "email": emailId,
        "college": college,
        "batch": batch,
        "emiratesID": emiratesID,
      }),
    );

    if (response.statusCode == 200) {
      print('User updated successfully');
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Request Sent Successfully')));
      return true;
    } else {
      print('Failed to update user: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send request')));
      return false;
    }
  }

  Future<Map<String, String>> submitPhoneNumber(
      String countryCode, BuildContext context, String phone) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Completer<String> verificationIdcompleter = Completer<String>();
    Completer<String> resendTokencompleter = Completer<String>();
    log('phone:+$countryCode$phone');
    await auth.verifyPhoneNumber(
      phoneNumber: '+$countryCode$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Handle automatic verification completion if needed
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message.toString());
        verificationIdcompleter.complete(''); // Verification failed
        resendTokencompleter.complete('');
      },
      codeSent: (String verificationId, int? resendToken) {
        log(verificationId);

        verificationIdcompleter.complete(verificationId);
        resendTokencompleter.complete(resendToken.toString());
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        if (!verificationIdcompleter.isCompleted) {
          verificationIdcompleter.complete(''); // Timeout without sending code
        }
      },
    );

    return {
      "verificationId": await verificationIdcompleter.future,
      "resendToken": await resendTokencompleter.future
    };
  }

  void resendOTP(
      String phoneNumber, String verificationId, String resendToken) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      forceResendingToken: int.parse(resendToken),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        // Auto-retrieval or instant verification
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle error
        print("Resend verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        resendToken = resendToken;
        print("Resend verification Sucess");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
      },
    );
  }

  Future<void> requestNFC(BuildContext context) async {
    final url = Uri.parse('$baseUrl/user/request/nfc');
    log("Requesting URL:${url}");
    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Review posted successfully');
        CustomSnackbar.showSnackbar(
            context, 'NFC requested sucessfully and we will mail you shortly');
      } else {
        print('Response body: ${response.body}');
        CustomSnackbar.showSnackbar(context, 'Already requested');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> blockUser(
      String userId, String? reason, context, WidgetRef ref) async {
    final String url = '$baseUrl/user/block/$userId';
    log('requesting url:$url');

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Success
        ref.invalidate(userProvider);

        print('User Blocked successfully');
        CustomSnackbar.showSnackbar(context, 'User Blocked');
      } else {
        // Handle error
        print('Failed to Block: ${response.statusCode}');
        final dynamic message = json.decode(response.body)['message'];
        log(message);
        CustomSnackbar.showSnackbar(context, 'Failed to block');
      }
    } catch (e) {
      // Handle exceptions
      print('An error occurred: $e');
    }
  }

  Future<void> unBlockUser(String userId, String reason, context) async {
    final String url = '$baseUrl/user/unblock/$userId';
    log('requesting url:$url');
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Success
        print('User unBlocked successfully');
        CustomSnackbar.showSnackbar(context, 'User unblocked');
      } else {
        // Handle error
        print('Failed to unBlock: ${response.statusCode}');
        final dynamic message = json.decode(response.body)['message'];
        log(message);
        CustomSnackbar.showSnackbar(context, 'Failed to unblock');
      }
    } catch (e) {
      // Handle exceptions
      print('An error occurred: $e');
    }
  }

  Future<void> createReport({
    required BuildContext context,
    required String description,
    required String reportedItemId,
    required String reportType,
  }) async {
    String url = '$baseUrl/report';
    try {
      final Map<String, dynamic> body = {
        'content': reportedItemId != null && reportedItemId != ''
            ? reportedItemId
            : ' ',
        'reportType': reportType,
        'description': description
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Include your token if authentication is required
        },
        body: jsonEncode(body),
      );

      // Handle the response
      if (response.statusCode == 201) {
        CustomSnackbar.showSnackbar(context, 'Reported to admin');

        print('Report created successfully');
      } else {
        CustomSnackbar.showSnackbar(context, 'Failed to Report');

        print('Failed to create report: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<String> verifyOTP(
      {required String verificationId,
      required String fcmToken,
      required String smsCode}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        String? idToken = await user.getIdToken();
        log("ID Token: $idToken");
        final token = await verifyUserDB(idToken!, fcmToken, context);
        return token;
      } else {
        print("User signed in, but no user information was found.");
        return '';
      }
    } catch (e) {
      log("Failed to sign in: ${e.toString()}");
      return '';
    }
  }

  Future<String> verifyUserDB(String idToken, String fcmToken, context) async {
    log('inside db');
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"clientToken": idToken, "fcm": fcmToken}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody['message']);

      return responseBody['data'];
    } else if (response.statusCode == 400) {
      return '';
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return '';
    }
  }

  Future<String> editUser(Map<String, dynamic> profileData) async {
    final url = Uri.parse('$baseUrl/user/update');
    log('updated profile data:$profileData');
    final response = await http.patch(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profileData),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
      print(json.decode(response.body)['message']);
      return json.decode(response.body)['message'];
    } else {
      print(json.decode(response.body)['message']);

      print('Failed to update profile. Status code: ${response.statusCode}');
      return json.decode(response.body)['message'];
      // throw Exception('Failed to update profile');
    }
  }

  String removeBaseUrl(String url) {
    String baseUrl = 'https://ackaf.s3.ap-south-1.amazonaws.com/';
    return url.replaceFirst(baseUrl, '');
  }

  Future<void> deleteFile(String token, String fileUrl) async {
    final reqfileUrl = removeBaseUrl(fileUrl);
    print(reqfileUrl);
    final url = Uri.parse('$baseUrl/files/delete/$reqfileUrl');
    print('requesting url:$url');
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Image deleted successfully');
    } else {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse['message']);
      print('Failed to delete image: ${response.statusCode}');
    }
  }

  Future<void> uploaPost(
      {required String type,
      required String? media,
      required String content}) async {
    final url = Uri.parse('$baseUrl/feeds');

    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'type': type,
      if (media != null && media != '') 'media': media,
      'content': content,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        print('Feed created successfully');
      } else {
        print('Failed to create feed: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deletePost(String token, String postId, context) async {
    final url = Uri.parse('$baseUrl/feeds/single/$postId');
    print('requesting url:$url');
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Post Deleted Successfully')));
    } else {
      final jsonResponse = json.decode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonResponse['message'])));
      print(jsonResponse['message']);
      print('Failed to delete image: ${response.statusCode}');
    }
  }

  Future<void> markEventAsRSVP(String eventId) async {
    final String url = '$baseUrl/event/single/$eventId';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Success

        print('RSVP marked successfully');
      } else {
        // Handle error
        final dynamic data = json.decode(response.body)['message'];
        print('Failed to mark RSVP: ${data}');
      }
    } catch (e) {
      // Handle exceptions
      print('An error occurred: $e');
    }
  }

  Future<void> likeFeed(String feedId) async {
    final url = Uri.parse('$baseUrl/feeds/like/$feedId');

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse['message']);
      } else {
        print('Failed to like the feed. Status code: ${response.statusCode}');
        // Handle errors or unsuccessful response here
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> postComment(
      {required String feedId, required String comment}) async {
    final url = Uri.parse('$baseUrl/feeds/comment/$feedId');

    // Replace with your actual token

    // Define the headers
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'accept': '*/*',
    };

    // Define the request body
    final body = jsonEncode({
      'comment': comment,
    });

    try {
      // Send the POST request
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Comment posted successfully');
      } else {
        print('Failed to post comment: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<String?> makePayment() async {
    final url = Uri.parse('$baseUrl/payment/make-payment');

    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Successfully made the payment
      print('Payment Success: ${response.body}');
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data'];
    } else {
      // Handle the error
      print('Payment Failed: ${response.statusCode} ${response.body}');
    }
  }

  Future<bool> updateUserStatus(
      {required String userId, required String status, String? reason}) async {
    final url = Uri.parse('$baseUrl/user/approval/$userId');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'status': status,
      'reason': reason,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Handle success
        print('User status updated successfully: ${response.body}');
        return true;
      } else {
        // Handle error
        final dynamic data = json.decode(response.body);
        print('Failed to update user status: ${response.statusCode}');
        log(data['message']);
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  
Future<UserModel> fetchUserDetails(userId) async {
  final url = Uri.parse('$baseUrl/user/single/$userId');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  log(response.body);
  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];

    return UserModel.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

}

@riverpod
Future<UserModel> fetchUserDetails(FetchUserDetailsRef ref) async {
  final url = Uri.parse('$baseUrl/user');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  log(response.body);
  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];

    return UserModel.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

//list of users
@riverpod
Future<List<UserModel>> fetchActiveUsers(FetchActiveUsersRef ref,
    {int pageNo = 1, int limit = 20, String? query}) async {
  // Construct the base URL
  Uri url = Uri.parse('$baseUrl/user/list?pageNo=$pageNo&limit=$limit');

  // Append query parameter if provided
  if (query != null && query.isNotEmpty) {
    url = Uri.parse(
        '$baseUrl/user/list?pageNo=$pageNo&limit=$limit&search=$query');
  }

  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final usersJson = data['data'] as List<dynamic>? ?? [];

    return usersJson.map((user) => UserModel.fromJson(user)).toList();
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load users');
  }
}

@riverpod
Future<List<UserModel>> fetchAllUsers(FetchAllUsersRef ref,
    {int pageNo = 1, int limit = 10}) async {
  final response = await http.get(
    Uri.parse('$baseUrl/user/users?pageNo=$pageNo&limit=$limit'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final usersJson = data['data'] as List<dynamic>? ?? [];

    return usersJson.map((user) => UserModel.fromJson(user)).toList();
  } else {
    final data = json.decode(response.body);
    log(data['message']);
    throw Exception('Failed to load users');
  }
}

@riverpod
Future<UserModel> fetchUserById(FetchUserByIdRef ref, String id) async {
  final url = Uri.parse('$baseUrl/user/single/$id');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  log(response.body);
  if (response.statusCode == 200) {
    final dynamic data = json.decode(response.body)['data'];

    return UserModel.fromJson(data);
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
