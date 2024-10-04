import 'dart:async';
import 'dart:developer';

import 'package:ackaf/src/data/globals.dart';

import 'package:ackaf/src/data/providers/loading_notifier.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final countryCode =
        ref.watch(countryCodeProvider); // Watch the countryCodeProvider

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: MediaQuery.of(context).size.height *
                      0.6, // 60% of screen height
                  width: double.infinity, // Takes the full width
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/loginImage.png',
                      fit: BoxFit
                          .cover, // Ensures the image covers the space proportionally
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: const Text(
                    'Please enter your mobile number',
                    style: TextStyle(
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: IntlPhoneField(
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
                      letterSpacing: 9,
                      fontSize:
                          18, // Adjusted for a more proportional text size
                      fontWeight: FontWeight.w400,
                    ),
                    // Makes the phone field non-editable
                    controller: _mobileController,
                    disableLengthCheck: true,
                    showCountryFlag: true, // Shows the country flag
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      hintStyle: const TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey,
                        fontSize: 14, // Adjust the hint text size
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Rectangular border with slight rounding
                        borderSide: BorderSide(
                          color: Colors.grey.shade400, // Light grey border
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey
                              .shade400, // Ensure the enabled border matches
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(
                          color: Colors.grey, // Color when the input is focused
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                    ),
                    onCountryChanged: (value) {
                      // Update the provider with the new country code
                      ref.read(countryCodeProvider.notifier).state =
                          value.dialCode;
                    },
                    initialCountryCode:
                        'AE', // India as the initial country code (adjust as needed)
                    onChanged: (PhoneNumber phone) {
                      print(phone.completeNumber);
                    },
                    flagsButtonPadding: const EdgeInsets.only(
                        left: 10,
                        right: 10.0), // Adjust padding around the flag
                    showDropdownIcon: true, // Shows dropdown icon
                    dropdownIconPosition:
                        IconPosition.trailing, // Places the icon at the end
                    dropdownTextStyle: const TextStyle(
                      fontSize: 15, // Font size of the country code
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: const Text(
                    'A 6 digit verification code will be sent ',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
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
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/loginImage.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: const Text(
                        'Please enter your OTP',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6, // Number of OTP digits
                        obscureText: false,
                        keyboardType:
                            TextInputType.number, // Number-only keyboard
                        animationType: AnimationType.fade,
                        textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 5.0,
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 60, selectedColor: Colors.red,
                          activeColor: Color.fromARGB(255, 232, 226, 226),
                          inactiveColor: const Color.fromARGB(
                              255, 232, 226, 226), // Box color when not focused
                          activeFillColor:
                              Colors.white, // Box color when focused
                          selectedFillColor:
                              Colors.white, // Box color when selected
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
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            _isButtonDisabled
                                ? 'Enter OTP in $_start seconds'
                                : 'Enter your OTP',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _isButtonDisabled
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _isButtonDisabled ? null : resendCode,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              _isButtonDisabled ? '' : 'Resend Code',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: _isButtonDisabled
                                    ? Colors.grey
                                    : Colors.red,
                              ),
                            ),
                          ),
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
            ),
          ),
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
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UserRegistrationScreen()));
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
