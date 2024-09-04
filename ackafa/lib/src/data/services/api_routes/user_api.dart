import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:ackaf/src/data/globals.dart';

import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/models/user_requirement_model.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_api.g.dart';

class ApiRoutes {
  final String baseUrl = 'http://3.108.205.101:3000/api/v1';
  // Future<String?> sendOtp(String mobile, context) async {
  //   print(mobile);
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/user/send-otp'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"phone": mobile}),
  //   );
  //   final Map<String, dynamic> responseBody = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     print(responseBody['message']);
  //     print(responseBody['data']);
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Success')));
  //     return responseBody['message'];
  //   } else if (response.statusCode == 400) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Invalid Mobile Number')));
  //     return null;
  //   } else {
  //     final Map<String, dynamic> responseBody = jsonDecode(response.body);
  //     print(responseBody['message']);
  //     return null;
  //   }
  // }

  // Future<List<dynamic>> verifyUser(String mobile, String otp, context) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/user/verify'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"otp": int.parse(otp), "phone": mobile}),
  //   );
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseBody = jsonDecode(response.body);
  //     print(responseBody['message']);
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Success')));
  //     return responseBody['data'];
  //   } else if (response.statusCode == 400) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Invalid OTP')));
  //     return [];
  //   } else {
  //     final Map<String, dynamic> responseBody = jsonDecode(response.body);
  //     print(responseBody['message']);
  //     return [];
  //   }
  // }

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

  Future<dynamic> createFileUrl({required File file, required token}) async {
    final url = Uri.parse('$baseUrl/files/upload');

    // Determine MIME type
    String fileName = file.path.split('/').last;
    String? mimeType;
    if (fileName.endsWith('.png')) {
      mimeType = 'image/png';
    } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
      mimeType = 'image/jpeg';
    } 
    else {
      return null; // Return null if the file type is unsupported
    }

    // Create multipart request
    final request = http.MultipartRequest('PUT', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['accept'] = 'application/json'
      ..headers['Content-Type'] = 'multipart/form-data'
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(mimeType),
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);

        return jsonResponse['data']; // Return the data part of the response
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Error Response Body: $responseBody');
        return null; // Return null or an error message
      }
    } catch (e) {
      print(e);
      return null; // Return null or an error message in case of an exception
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

  Future<void> markNotificationAsRead(String notificationId) async {
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

  Future<String?> uploadRequirement(
    String token,
    String author,
    String content,
    String status,
    File file,
  ) async {
    const String url = 'http://43.205.89.79/api/v1/requirements';

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    // Add fields
    request.fields['author'] = author;
    request.fields['content'] = content;
    request.fields['status'] = status;

    // Add the file
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();
    var multipartFile = http.MultipartFile(
      'invoice_url',
      stream,
      length,
      filename: basename(file.path),
      contentType: MediaType('image', 'png'),
    );

    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    if (response.statusCode == 201) {
      print('Requirement submitted successfully');
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      return jsonResponse['message'];
    } else {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      print(jsonResponse['message']);
      print('Failed to submit requirement: ${response.statusCode}');
      return null;
    }
  }

  Future<String?> uploadPayment(
    String token,
    String category,
    String remarks,
    File file,
  ) async {
    const String url = 'http://43.205.89.79/api/v1/payments/user';

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll({
      'accept': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7InVzZXJJZCI6IjY2YzM4ZTRkYjlhYTE0N2MyMzAzMzliZiJ9LCJpYXQiOjE3MjQ0MDE4ODh9.lcLy_lfd606IwPduyoW7geWYsHBjtAtmNcSshQV0eHM',
      'Content-Type': 'multipart/form-data',
    });

    // Add fields
    request.fields['category'] = category;
    request.fields['remarks'] = remarks;

    // Add the file
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();
    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(file.path),
      contentType: MediaType('image', 'png'),
    );

    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    if (response.statusCode == 201) {
      print('Payment submitted successfully');
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      return jsonResponse['message'];
    } else {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      print(jsonResponse['message']);
      print('Failed to submit Payment: ${response.statusCode}');
      return 'Failed';
    }
  }
}

Future<void> markEventAsRSVP(String eventId) async {
  final String url = 'http://43.205.89.79/api/v1/events/rsvp/$eventId/mark';
  final String bearerToken = '$token';

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      // Success
      print('RSVP marked successfully');
    } else {
      // Handle error
      print('Failed to mark RSVP: ${response.statusCode}');
    }
  } catch (e) {
    // Handle exceptions
    print('An error occurred: $e');
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

@riverpod
Future<List<UserModel>> fetchUsers(FetchUsersRef ref, String token) async {
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
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<UserModel> events = [];

    for (var item in data) {
      events.add(UserModel.fromJson(item));
    }
    print(events);
    return events;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}

@riverpod
Future<List<UserRequirementModel>> fetchUserRequirements(
    FetchUserRequirementsRef ref, String token) async {
  final url = Uri.parse('$baseUrl/requirements/$id');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<UserRequirementModel> userRequirements = [];

    for (var item in data) {
      userRequirements.add(UserRequirementModel.fromJson(item));
    }
    print(userRequirements);
    return userRequirements;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
