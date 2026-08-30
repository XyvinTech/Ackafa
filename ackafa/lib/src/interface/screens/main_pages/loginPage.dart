import 'dart:async';
import 'dart:developer';

import 'package:ackaf/src/data/globals.dart';

import 'package:ackaf/src/data/providers/loading_notifier.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:ackaf/src/interface/common/loading.dart';

import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_registrationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';

import 'package:ackaf/src/interface/common/custom_button.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
        ],
      ),
    );
  }
}

final countryCodeProvider = StateProvider<String?>((ref) => '971');

class PhoneNumberScreen extends ConsumerWidget {
  final VoidCallback onNext;

  PhoneNumberScreen({super.key, required this.onNext});

  static const Color _background = Colors.white;
  static const Color _inputFill = Color(0xFFF7F2F1);
  static const Color _subtitleColor = Color(0xFF757575);
  static const Color _hintColor = Color(0xFFB0A8A6);
  static const Color _dividerColor = Color(0xFFD9D2D0);
  static const Color _buttonColor = Color(0xFFC60E18);
  static const double _horizontalPadding = 24.0;
  static const double _fieldRadius = 12.0;
  static const double _fieldHeight = 56.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final countryCode =
        ref.watch(countryCodeProvider); // Watch the countryCodeProvider
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: _background,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      _horizontalPadding,
                      48,
                      _horizontalPadding,
                      24 + bottomInset,
                    ),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "What's your number?",
                          style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "We'll text a 4 digit code to make sure its really you",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: _subtitleColor,
                          ),
                        ),
                        const SizedBox(height: 36),
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        IntlPhoneField(
                          validator: (phone) {
                            if (phone!.number.length > 9) {
                              if (countryCode == '971') {
                                return 'Phone number cannot exceed 9 digits';
                              } else if (phone.number.length > 10) {
                                return 'Phone number cannot exceed 10 digits';
                              }
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 0.2,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          controller: _mobileController,
                          disableLengthCheck: true,
                          showCountryFlag: false,
                          autovalidateMode: AutovalidateMode.disabled,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _inputFill,
                            hintText: 'Enter phone number',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              color: _hintColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_fieldRadius),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_fieldRadius),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_fieldRadius),
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_fieldRadius),
                              borderSide: BorderSide.none,
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_fieldRadius),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18.0,
                              horizontal: 12.0,
                            ),
                            counterText: '',
                          ),
                          onCountryChanged: (value) {
                            // Update the provider with the new country code
                            ref.read(countryCodeProvider.notifier).state =
                                value.dialCode;
                          },
                          initialCountryCode: 'AE',
                          onChanged: (PhoneNumber phone) {
                            print(phone.completeNumber);
                          },
                          flagsButtonPadding: const EdgeInsets.only(
                            left: 14,
                            right: 8,
                            top: 4,
                            bottom: 4,
                          ),
                          flagsButtonMargin: const EdgeInsets.only(right: 4),
                          showDropdownIcon: true,
                          dropdownIconPosition: IconPosition.trailing,
                          dropdownIcon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: Color(0xFF1A1A1A),
                          ),
                          dropdownTextStyle: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A),
                          ),
                          dropdownDecoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: _dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    _horizontalPadding,
                    8,
                    _horizontalPadding,
                    24 + (bottomInset > 0 ? 8 : 0),
                  ),
                  child: SizedBox(
                    height: _fieldHeight,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? () {}
                          : () {
                              _handleOtpGeneration(context, ref);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _buttonColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_fieldRadius),
                        ),
                      ),
                      child: const Text(
                        'Send Code',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: LoadingAnimation(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleOtpGeneration(BuildContext context, WidgetRef ref) async {
    final countryCode = ref.watch(countryCodeProvider);
    ref.read(loadingProvider.notifier).startLoading();

    try {
      if (countryCode == '971') {
        if (_mobileController.text.length != 9) {
          CustomSnackbar.showSnackbar(
              context, 'Please Enter Valid Phone numbe!');
        } else {
          ApiRoutes userApi = ApiRoutes();

          final data = await userApi.submitPhoneNumber(
              countryCode == '971'
                  ? 9710.toString()
                  : countryCode ?? 971.toString(),
              context,
              _mobileController.text);
          final verificationId = data['verificationId'];
          final resendToken = data['resendToken'];
          if (verificationId != null && verificationId.isNotEmpty) {
            log('Otp Sent successfully');
            onNext();
            _mobileController.clear();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => OTPScreen(
                phone: _mobileController.text,
                verificationId: verificationId,
                resendToken: resendToken ?? '',
              ),
            ));
          } else {
            CustomSnackbar.showSnackbar(context, 'Failed!');
          }
        }
      } else if (countryCode != '971') {
        if (_mobileController.text.length != 10) {
          CustomSnackbar.showSnackbar(
              context, 'Please Enter Valid Phone number!');
        } else {
          ApiRoutes userApi = ApiRoutes();

          final data = await userApi.submitPhoneNumber(
              countryCode == '971'
                  ? 9710.toString()
                  : countryCode ?? 971.toString(),
              context,
              _mobileController.text);
          final verificationId = data['verificationId'];
          final resendToken = data['resendToken'];
          if (verificationId != null && verificationId.isNotEmpty) {
            log('Otp Sent successfully');
            onNext();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => OTPScreen(
                phone: _mobileController.text,
                verificationId: verificationId,
                resendToken: resendToken ?? '',
              ),
            ));
          } else {
            CustomSnackbar.showSnackbar(context, 'Failed!');
          }
        }
      }
    } catch (e) {
      CustomSnackbar.showSnackbar(context, 'Failed');
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }
}

class OTPScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String resendToken;
  final String phone;
  const OTPScreen({
    required this.phone,
    required this.resendToken,
    super.key,
    required this.verificationId,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  Timer? _timer;

  int _start = 59;

  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isButtonDisabled = true;
    _start = 59;
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
    userApi.resendOTP(widget.phone, widget.verificationId, widget.resendToken);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final countryCode = ref.watch(countryCodeProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 20,
            right: 0,
            left: 0,
            child: Image.asset(
              'assets/splashAkcaf.png',
              scale: 1.3,
            ),
          ),
          Positioned(
            top: 280,
            right: 0,
            left: 0,
            child: Image.asset(
              'assets/worldmap.png',
              scale: 1,
            ),
          ),
          const Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'OTP Verification',
                style: TextStyle(
                    color: Color(0xFFE30613),
                    fontFamily: 'Fraunces',
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: 25),
              ),
            ),
          ),
          const Positioned(
            top: 340,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Please enter the OTP',
                style: TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
          ),
          Positioned(
            top: 380,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: PinCodeTextField(
                appContext: context,
                length: 6, // Number of OTP digits
                obscureText: false,
                keyboardType: TextInputType.number, // Number-only keyboard
                animationType: AnimationType.fade,
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 5.0,
                ),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(20),
                  fieldHeight: 55,
                  fieldWidth: 50, selectedColor: Colors.red,
                  activeColor: const Color.fromARGB(255, 232, 226, 226),
                  inactiveColor: const Color.fromARGB(
                      255, 232, 226, 226), // Box color when not focused
                  activeFillColor: Colors.white, // Box color when focused
                  selectedFillColor: Colors.white, // Box color when selected
                  inactiveFillColor:
                      Colors.white, // Box fill color when not selected
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                controller: _otpController,
                onChanged: (value) {
                  // Handle input change
                },
              ),
            ),
          ),
          Positioned(
            top: 450,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    _isButtonDisabled
                        ? 'Resend OTP in $_start seconds'
                        : 'Enter your OTP',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _isButtonDisabled ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _isButtonDisabled ? null : resendCode,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      _isButtonDisabled ? '' : 'Resend Code',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: _isButtonDisabled ? Colors.grey : Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 480,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SizedBox(
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
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: LoadingAnimation(),
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
      String savedToken = await userApi.verifyOTP(
        verificationId: widget.verificationId,
        fcmToken: fcmToken,
        smsCode: _otpController.text,
      );

      if (savedToken.isNotEmpty) {
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        await preferences.setString('token', savedToken);
        token = savedToken;
        log('savedToken: $savedToken');
        ref.invalidate(userProvider);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const UserRegistrationScreen()));
      } else {
        CustomSnackbar.showSnackbar(context, 'Wrong OTP');
      }
    } catch (e) {
      CustomSnackbar.showSnackbar(context, 'Wrong OTP');
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }
}

InkWell _buildbutton(
    {required String label,
    IconData? icondata,
    required String model,
    String? countryCode}) {
  return InkWell(
      onTap: () {
        _onbuttonTap(label, model, countryCode ?? '971');
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

_onbuttonTap(var value, String model, String countryCode) {
  if (model == "mobile") {
    if (value == 'back') {
      if (_mobileController.text.isNotEmpty) {
        _mobileController.text = _mobileController.text
            .substring(0, _mobileController.text.length - 1);
      }
    } else if (countryCode == '971' && _mobileController.text.length < 9) {
      log('Country code:$countryCode');
      _mobileController.text += value;
    } else if (countryCode != '971' && _mobileController.text.length < 10) {
      log('Country code:$countryCode');
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
