import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/college_model.dart';
import 'package:ackaf/src/data/providers/loading_notifier.dart';
import 'package:ackaf/src/data/services/api_routes/college_api.dart';
import 'package:ackaf/src/interface/common/custom_dialog.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/profile_completetion_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_details_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_registrationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';

import 'package:ackaf/src/interface/common/custom_button.dart';

import 'package:shared_preferences/shared_preferences.dart';

TextEditingController _mobileController = TextEditingController();
TextEditingController _otpController = TextEditingController();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PageController _pageController = PageController();

  void _nextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: [
          PhoneNumberScreen(onNext: _nextPage),
          ProfileCompletionScreen(),
        ],
      ),
    );
  }
}

class PhoneNumberScreen extends ConsumerWidget {
  final VoidCallback onNext;

  const PhoneNumberScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/icons/ackaf_logo.png',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your Phone Number',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
                const SizedBox(height: 20),
                IntlPhoneField(
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 5.0,
                  ),
                  readOnly: true,
                  controller: _mobileController,
                  disableLengthCheck: true,
                  showCountryFlag: false,
                  decoration: const InputDecoration(
                    hintText: '0000000000',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 5.0,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (PhoneNumber phone) {
                    print(phone.completeNumber);
                  },
                  flagsButtonPadding: EdgeInsets.zero,
                  showDropdownIcon: true,
                  dropdownIconPosition: IconPosition.trailing,
                  dropdownTextStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'We will send you the 4 digit Verification code',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
                const Spacer(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildbutton(label: '1', model: 'mobile'),
                        _buildbutton(label: '2', model: 'mobile'),
                        _buildbutton(label: '3', model: 'mobile')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildbutton(label: '4', model: 'mobile'),
                        _buildbutton(label: '5', model: 'mobile'),
                        _buildbutton(label: '6', model: 'mobile')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildbutton(label: '7', model: 'mobile'),
                        _buildbutton(label: '8', model: 'mobile'),
                        _buildbutton(label: '9', model: 'mobile')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildbutton(label: 'ABC', model: ''),
                        _buildbutton(label: '0', model: 'mobile'),
                        _buildbutton(
                            label: 'back',
                            icondata: Icons.arrow_back_ios,
                            model: 'mobile')
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SizedBox(
                    height: 47,
                    width: double.infinity,
                    child: customButton(
                      label: 'GENERATE OTP',
                      onPressed: isLoading
                          ? () {}
                          : () {
                              _handleOtpGeneration(context, ref);
                            },
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleOtpGeneration(BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).startLoading();

    try {
      if (_mobileController.text.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please Enter Valid Phone number')),
        );
      } else {
        ApiRoutes userApi = ApiRoutes();
        final data =
            await userApi.submitPhoneNumber(context, _mobileController.text);
        final verificationId = data['verificationId'];
        final resendToken = data['resendToken'];
        if (verificationId != null && verificationId.isNotEmpty) {
          log('Otp Sent successfully');
          onNext();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OTPScreen(phone: _mobileController.text,
              verificationId: verificationId,
              resendToken: resendToken ?? '',

            ),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed')),
      );
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }
}

class OTPScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String resendToken;
  final String phone;
  const OTPScreen( {required this.phone,
    required this.resendToken,
    super.key,
    required this.verificationId,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  Timer? _timer;

  int _start = 20;

  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isButtonDisabled = true;
    _start = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void resendCode() {
    startTimer();
    ApiRoutes userApi = ApiRoutes();
    userApi.resendOTP(widget.phone,widget.verificationId, widget.resendToken);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/icons/ackaf_logo.png',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your OTP',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 5.0,
                  ),
                  readOnly: true,
                  controller: _otpController,
                  decoration: const InputDecoration(
                    hintText: '000000',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 5.0,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _isButtonDisabled
                      ? null
                      : () {
                          resendCode();
                        },
                  child: Text(
                    _isButtonDisabled
                        ? 'Resend Code in $_start s'
                        : 'Resend Code',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _isButtonDisabled ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildbutton(label: '1', model: 'otp'),
                        _buildbutton(label: '2', model: 'otp'),
                        _buildbutton(label: '3', model: 'otp')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildbutton(label: '4', model: 'otp'),
                        _buildbutton(label: '5', model: 'otp'),
                        _buildbutton(label: '6', model: 'otp')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildbutton(label: '7', model: 'otp'),
                        _buildbutton(label: '8', model: 'otp'),
                        _buildbutton(label: '9', model: 'otp')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildbutton(label: 'ABC', model: ''),
                        _buildbutton(label: '0', model: 'otp'),
                        _buildbutton(
                            label: 'back',
                            icondata: Icons.arrow_back_ios,
                            model: 'otp')
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SizedBox(
                    height: 47,
                    width: double.infinity,
                    child: customButton(
                      label: 'NEXT',
                      onPressed: isLoading
                          ? () {}
                          : () {
                              _handleOtpVerification(context, ref);
                            },
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleOtpVerification(
      BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).startLoading();

    try {
      print(_otpController.text);

      ApiRoutes userApi = ApiRoutes();
      String savedToken =
          await userApi.verifyOTP(widget.verificationId, _otpController.text);

      if (savedToken.isNotEmpty) {
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        await preferences.setString('token', savedToken);
        token = savedToken;
        log('savedToken: $savedToken');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => UserDetailsScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wrong OTP')),
      );
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }
}

InkWell _buildbutton({
  required String label,
  IconData? icondata,
  required String model,
}) {
  return InkWell(
      onTap: () {
        _onbuttonTap(label, model);
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          width: 80, // Adjusted width to fit better
          child: DecoratedBox(
            decoration: const BoxDecoration(),
            child: Center(
              child: icondata != null
                  ? Icon(icondata,
                      size: 19, color: const Color.fromARGB(255, 139, 138, 138))
                  : Text(
                      label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                          color: Color.fromARGB(255, 117, 116, 116)),
                    ),
            ),
          ),
        ),
      ));
}

_onbuttonTap(var value, String model) {
  if (model == "mobile") {
    if (value == 'back') {
      if (_mobileController.text.isNotEmpty) {
        _mobileController.text = _mobileController.text
            .substring(0, _mobileController.text.length - 1);
      }
    } else if (_mobileController.text.length < 10) {
      _mobileController.text += value;
    } else {}
  } else if (model == "otp") {
    if (value == 'back') {
      if (_otpController.text.isNotEmpty) {
        _otpController.text =
            _otpController.text.substring(0, _otpController.text.length - 1);
      }
    } else {
      if (_otpController.text.length < 6) {
        _otpController.text += value;
        if (_otpController.text.length == 5) {}
      } else {}
    }
  } else {}
}
