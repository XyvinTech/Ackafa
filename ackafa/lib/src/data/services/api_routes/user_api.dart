import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:developer';
import 'dart:io';

import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:ackaf/src/data/globals.dart';

import 'package:ackaf/src/data/models/user_model.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_api.g.dart';

class ApiRoutes {
  final String baseUrl = 'http://3.108.205.101:3000/api/v1';

  Future<bool> updateUser(
      {required String token,
      required String? profileUrl,
      required String? firstName,
      required String? middleName,
      required String? lastName,
      required String? emailId,
      required String? college,
      required String? batch,
      required String? course,
      required context}) async {
    final url = Uri.parse('http://3.108.205.101:3000/api/v1/user/update');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: jsonEncode({
        "name": {"first": firstName, "middle": middleName, "last": lastName},
        "image": profileUrl,
        "email": emailId,
        "college": college,
        "course": course.toString(),
        "batch": batch,
      }),
    );

    if (response.statusCode == 200) {
      print('User updated successfully');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request Sent Successfully')));
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
      BuildContext context, String phone) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Completer<String> verificationIdcompleter = Completer<String>();
    Completer<String> resendTokencompleter = Completer<String>();
    await auth.verifyPhoneNumber(
      phoneNumber: '+91$phone',
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

  Future<String> verifyOTP(String verificationId, String smsCode) async {
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
        final token = await verifyUserDB(idToken!, context);
        return token;
      } else {
        print("User signed in, but no user information was found.");
        return '';
      }
    } catch (e) {
      print("Failed to sign in: ${e.toString()}");
      return '';
    }
  }

  Future<String> verifyUserDB(String idToken, context) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"clientToken": idToken}),
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

  Future<void> editUser(Map<String, dynamic> profileData) async {
    final url = Uri.parse('$baseUrl/user/update');

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
    } else {
      print(json.decode(response.body)['message']);
      print('Failed to update profile. Status code: ${response.statusCode}');
      throw Exception('Failed to update profile');
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
      required String media,
      required String content}) async {
    final url = Uri.parse('$baseUrl/feeds');

    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'type': type,
      'media': media,
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

  Future<void> deleteRequirement(
      String token, String requirementId, context) async {
    final url = Uri.parse('$baseUrl/requirements/$requirementId');
    print('requesting url:$url');
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Requirement Deleted Successfully')));
    } else {
      final jsonResponse = json.decode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonResponse['message'])));
      print(jsonResponse['message']);
      print('Failed to delete image: ${response.statusCode}');
    }
  }

  Future<void> markNotificationAsRead(String notificationId, String id) async {
    final url = Uri.parse(
        'http://43.205.89.79/api/v1/notification/in-app/$notificationId/read/$id');

    final response = await http.put(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwidXNlcklkIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjJ9.gw7m0eu3gxSoavEQa4aIt48YZVQz_EsuZ0nJDrjXKuI',
      },
    );

    if (response.statusCode == 200) {
      print('Notification marked as read successfully.');
    } else {
      print(
          'Failed to mark notification as read. Status code: ${response.statusCode}');
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


  Future<void> postComment({required String feedId,required String comment}) async {
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
}

const String baseUrl = 'http://3.108.205.101:3000/api/v1';

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
Future<List<UserModel>> fetchUsers(FetchUsersRef ref,
    {int pageNo = 1, int limit = 10}) async {
  final response = await http.get(
    Uri.parse('$baseUrl/user/list?pageNo=$pageNo&limit=$limit'),
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
