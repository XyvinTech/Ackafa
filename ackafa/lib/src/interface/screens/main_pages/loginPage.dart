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
    final countryCode = ref.read(countryCodeProvider) ?? '971';
    final phone = _mobileController.text.trim();
    final expectedLength = countryCode == '971' ? 9 : 10;

    if (phone.length != expectedLength) {
      CustomSnackbar.showSnackbar(context, 'Please Enter Valid Phone number!');
      return;
    }

    ref.read(loadingProvider.notifier).startLoading();

    try {
      ApiRoutes userApi = ApiRoutes();
      final data = await userApi.submitPhoneNumber(
        countryCode,
        context,
        phone,
      );
      final verificationId = data['verificationId'];
      final resendToken = data['resendToken'];
      final errorMessage = data['error'];

      if (verificationId != null && verificationId.isNotEmpty) {
        log('Otp Sent successfully');
        onNext();
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => OTPScreen(
            phone: phone,
            verificationId: verificationId,
            resendToken: resendToken ?? '',
          ),
        ));
      } else {
        log('OTP send failed: ${errorMessage ?? 'unknown'}');
        if (!context.mounted) return;
        CustomSnackbar.showSnackbar(
          context,
          (errorMessage != null && errorMessage.isNotEmpty)
              ? errorMessage
              : 'Failed to send OTP',
        );
      }
    } catch (e, st) {
      log('OTP send exception: $e', stackTrace: st);
      if (!context.mounted) return;
      CustomSnackbar.showSnackbar(context, 'Failed to send OTP');
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

  String get _formattedTimer {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _formattedPhone(String? countryCode) {
    final dial = countryCode ?? '971';
    final number = widget.phone.trim();
    if (number.length == 10) {
      return '+$dial ${number.substring(0, 5)} ${number.substring(5)}';
    }
    if (number.length == 9) {
      return '+$dial ${number.substring(0, 3)} ${number.substring(3, 6)} ${number.substring(6)}';
    }
    return '+$dial $number';
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final countryCode = ref.watch(countryCodeProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    const background = Colors.white;
    const subtitleColor = Color(0xFF757575);
    const pinFill = Color(0xFFFDF6F6);
    const pinBorder = Color(0xFFF3DADA);
    const pinFocused = Color(0xFFC60E18);
    const buttonColor = Color(0xFFC60E18);
    const horizontalPadding = 24.0;
    const fieldRadius = 12.0;
    const buttonHeight = 56.0;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: background,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      48,
                      horizontalPadding,
                      24 + bottomInset,
                    ),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter the code',
                          style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Send to ${_formattedPhone(countryCode)}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: subtitleColor,
                          ),
                        ),
                        const SizedBox(height: 36),
                        const Text(
                          'OTP',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Keep existing 6-digit OTP length; size boxes to fit width.
                            const gap = 8.0;
                            const length = 6;
                            final available = constraints.maxWidth;
                            final fieldWidth =
                                ((available - (gap * (length - 1))) / length)
                                    .clamp(40.0, 56.0);
                            final fieldHeight = fieldWidth;

                            return PinCodeTextField(
                              appContext: context,
                              length: length,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              animationType: AnimationType.fade,
                              autoDisposeControllers: false,
                              textStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius:
                                    BorderRadius.circular(fieldRadius),
                                fieldHeight: fieldHeight,
                                fieldWidth: fieldWidth,
                                borderWidth: 1,
                                activeColor: pinBorder,
                                selectedColor: pinFocused,
                                inactiveColor: pinBorder,
                                activeFillColor: pinFill,
                                selectedFillColor: pinFill,
                                inactiveFillColor: pinFill,
                              ),
                              animationDuration:
                                  const Duration(milliseconds: 200),
                              backgroundColor: Colors.transparent,
                              enableActiveFill: true,
                              controller: _otpController,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              onChanged: (value) {
                                // Handle input change
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_isButtonDisabled)
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1A1A1A),
                              ),
                              children: [
                                const TextSpan(text: 'Resend code in : '),
                                TextSpan(
                                  text: _formattedTimer,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: resendCode,
                            child: const Text(
                              'Resend Code',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: buttonColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    8,
                    horizontalPadding,
                    24 + (bottomInset > 0 ? 8 : 0),
                  ),
                  child: SizedBox(
                    height: buttonHeight,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? () {}
                          : () {
                              _handleOtpVerification(context, ref);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(fieldRadius),
                        ),
                      ),
                      child: const Text(
                        'Verify Code',
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
