import 'dart:developer';
import 'dart:io';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/college_model.dart';
import 'package:ackaf/src/data/models/user_model.dart';
// removed unused imports
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/api_routes/college_api.dart';
import 'package:ackaf/src/data/services/api_routes/image_upload.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/paymentpage.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/profile_completetion_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/subcription_expired_page.dart';

import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_inactive_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  File? _profileImageFile;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController firstController = TextEditingController();
  final TextEditingController middleController = TextEditingController();
  final TextEditingController lastController = TextEditingController();

  final TextEditingController emirateIDController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String _resolveUserStatus(String? status) {
    final s = status?.toLowerCase() ?? 'inactive';
    if (!isPaymentEnabled &&
        (s == 'awaiting_payment' || s == 'subscription_expired')) {
      return 'active';
    }
    return s;
  }

  Future<void> _pickImage(ImageSource source, context) async {
    _pickFile(source);
  }

  Future<File?> _pickFile(source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _profileImageFile = File(image.path);
      });
      return _profileImageFile;
    }
    return null;
  }

  ApiRoutes userApi = ApiRoutes();

  int? selectedCollegeIndex = -1;
  String? profileImageUrl;
  College? selectedCollege;
  String? selectedBatch;
  String? selectedGender;
  Course? selectedCourse;
  String? selectedCollegeId;
  String? selectedCourseId;
  final _formKey = GlobalKey<FormState>();
  void _populateControllersWithUserData(UserModel user) {
    if (nameController.text.isEmpty && user.fullName != null) {
      nameController.text = user.fullName!;
    }
    if (emailController.text.isEmpty && user.email != null) {
      emailController.text = user.email!;
    }
    if (emirateIDController.text.isEmpty && user.emiratesID != null) {
      emirateIDController.text = user.emiratesID!;
    }
    if (selectedGender == null && user.gender != null) {
      selectedGender = user.gender;
    }
    if (selectedBatch == null && user.batch != null) {
      selectedBatch = user.batch.toString();
    }
  }

  void _populateCollegeAndCourseData(UserModel user, List<College> colleges) {
    if (selectedCollege == null && user.college != null) {
      final userCollegeId = user.college!.id;
      log('Looking for user college ID: $userCollegeId');
      log('Available colleges: ${colleges.map((c) => '${c.id}: ${c.collegeName}').join(', ')}');

      final collegeIndex =
          colleges.indexWhere((college) => college.id == userCollegeId);

      if (collegeIndex != -1) {
        log('Found college at index $collegeIndex: ${colleges[collegeIndex].collegeName}');
        setState(() {
          selectedCollege = colleges[collegeIndex];
          selectedCollegeIndex = collegeIndex;
          selectedCollegeId = userCollegeId;
        });
        _setCourseFromUserData(user, colleges[collegeIndex]);
      } else {
        log('User college not found in available colleges: $userCollegeId');
      }
    }
  }

  void _setCourseFromUserData(UserModel user, College selectedCollegeData) {
    if (selectedCourse == null && user.course != null) {
      final userCourseId = user.course!.id;
      final availableCourses = selectedCollegeData.course ?? [];

      try {
        final matchingCourse = availableCourses.firstWhere(
          (course) => course.id == userCourseId,
        );

        setState(() {
          selectedCourse = matchingCourse;
        });
      } catch (e) {
        log('User course not found in available courses: $userCourseId');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return asyncUser.when(
          data: (user) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _populateControllersWithUserData(user);
            });
            if (user.batch == null) {
              return Consumer(
                builder: (context, ref, child) {
                  final asyncColleges = ref.watch(fetchCollegesProvider(token));
                  return asyncColleges.when(
                    data: (colleges) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _populateCollegeAndCourseData(user, colleges);
                      });

                      return RefreshIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.red,
                        onRefresh: () async => ref.invalidate(userProvider),
                        child: Scaffold(
                          backgroundColor: Colors.white,
                          body: SafeArea(
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        padding: EdgeInsets.fromLTRB(
                                          _RegistrationStyles.horizontalPadding,
                                          48,
                                          _RegistrationStyles.horizontalPadding,
                                          24,
                                        ),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'A little about you',
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
                                                'This is how members will find and recognize you.',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.4,
                                                  color: _RegistrationStyles
                                                      .subtitleColor,
                                                ),
                                              ),
                                              const SizedBox(height: 36),
                                              _RegistrationTextField(
                                                label: 'Full name',
                                                hint: 'Enter name',
                                                controller: nameController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Enter your Full Name';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  ref
                                                      .read(
                                                          userProvider.notifier)
                                                      .updateName(name: value);
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              _RegistrationTextField(
                                                label: 'Email',
                                                hint: 'Enter email',
                                                controller: emailController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Enter your Email ID';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  ref
                                                      .read(
                                                          userProvider.notifier)
                                                      .updateEmail(value);
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              FormField<String>(
                                                builder: (FormFieldState<String>
                                                    state) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _RegistrationDropdown<
                                                          String>(
                                                        label: 'Gender',
                                                        hint: 'Select',
                                                        value: selectedGender,
                                                        items: const [
                                                          DropdownMenuItem(
                                                            value: 'Male',
                                                            child: Text('Male'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 'Female',
                                                            child:
                                                                Text('Female'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 'Other',
                                                            child:
                                                                Text('Other'),
                                                          ),
                                                        ],
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            selectedGender =
                                                                value;
                                                            state.didChange(
                                                                value);
                                                          });
                                                        },
                                                      ),
                                                      if (state.hasError)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          child: Text(
                                                            state.errorText!,
                                                            style:
                                                                const TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              FormField<College>(
                                                validator: (value) {
                                                  if (selectedCollege == null) {
                                                    return 'Please select a college';
                                                  }
                                                  return null;
                                                },
                                                builder:
                                                    (FormFieldState<College>
                                                        state) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _RegistrationDropdown<
                                                          College>(
                                                        label: 'College',
                                                        hint: 'Select',
                                                        value: selectedCollege,
                                                        items: colleges
                                                            .map((college) {
                                                          return DropdownMenuItem<
                                                              College>(
                                                            value: college,
                                                            child: Text(
                                                              college
                                                                  .collegeName!,
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (College? value) {
                                                          setState(() {
                                                            selectedCollege =
                                                                value;
                                                            selectedCollegeIndex =
                                                                colleges
                                                                    .indexWhere(
                                                              (college) =>
                                                                  college.id ==
                                                                  value?.id,
                                                            );
                                                            selectedCollegeId =
                                                                value?.id;
                                                            selectedCourse =
                                                                null;
                                                            selectedBatch =
                                                                null;
                                                            state.didChange(
                                                                value);
                                                          });
                                                        },
                                                      ),
                                                      if (state.hasError)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          child: Text(
                                                            state.errorText!,
                                                            style:
                                                                const TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              FormField<Course>(
                                                builder: (FormFieldState<Course>
                                                    state) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _RegistrationDropdown<
                                                          Course>(
                                                        label: 'Course',
                                                        hint: 'Select',
                                                        value: selectedCourse,
                                                        items: selectedCollegeIndex !=
                                                                -1
                                                            ? colleges[
                                                                    selectedCollegeIndex!]
                                                                .course!
                                                                .map((course) {
                                                                return DropdownMenuItem<
                                                                    Course>(
                                                                  value: course,
                                                                  child: Text(
                                                                    course
                                                                        .toString(),
                                                                  ),
                                                                );
                                                              }).toList()
                                                            : [],
                                                        onChanged:
                                                            (Course? value) {
                                                          setState(() {
                                                            selectedCourse =
                                                                value;
                                                            state.didChange(
                                                                value);
                                                          });
                                                        },
                                                      ),
                                                      if (state.hasError)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          child: Text(
                                                            state.errorText!,
                                                            style:
                                                                const TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              FormField<String>(
                                                validator: (value) {
                                                  if (selectedBatch == null) {
                                                    return 'Please select a batch';
                                                  }
                                                  return null;
                                                },
                                                builder: (FormFieldState<String>
                                                    state) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _RegistrationDropdown<
                                                          String>(
                                                        label: 'Batch',
                                                        hint: 'Select',
                                                        value: selectedBatch,
                                                        items: selectedCollegeIndex !=
                                                                -1
                                                            ? colleges[
                                                                    selectedCollegeIndex!]
                                                                .batch!
                                                                .map((batch) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: batch
                                                                      .toString(),
                                                                  child: Text(
                                                                    batch
                                                                        .toString(),
                                                                  ),
                                                                );
                                                              }).toList()
                                                            : [],
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            selectedBatch =
                                                                value;
                                                            state.didChange(
                                                                value);
                                                          });
                                                        },
                                                      ),
                                                      if (state.hasError)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          child: Text(
                                                            state.errorText!,
                                                            style:
                                                                const TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        _RegistrationStyles.horizontalPadding,
                                        8,
                                        _RegistrationStyles.horizontalPadding,
                                        24,
                                      ),
                                      child: SizedBox(
                                        height:
                                            _RegistrationStyles.buttonHeight,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              try {
                                                if (_profileImageFile != null &&
                                                    _profileImageFile != '') {
                                                  profileImageUrl =
                                                      await imageUpload(
                                                    _profileImageFile!.path,
                                                  );
                                                }

                                                print(profileImageUrl);
                                                log(token);

                                                final response =
                                                    await userApi.registerUser(
                                                  token: token,
                                                  profileUrl: profileImageUrl,
                                                  name: nameController.text,
                                                  gender: selectedGender,
                                                  emailId: emailController.text,
                                                  college: selectedCollegeId,
                                                  batch: selectedBatch,
                                                  context: context,
                                                );

                                                if (response) {
                                                  final resolved =
                                                      _resolveUserStatus(
                                                          user.status);
                                                  log('user status: ${user.status} -> $resolved');
                                                  if (resolved == 'active') {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileCompletionScreen(),
                                                      ),
                                                    );
                                                  } else if (resolved ==
                                                      'awaiting_payment') {
                                                    log('im in payment condition ok');
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PaymentConfirmationPage(),
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const UserInactivePage(),
                                                      ),
                                                    );
                                                  }
                                                }
                                              } catch (e) {
                                                CustomSnackbar.showSnackbar(
                                                    context, '$e');
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                _RegistrationStyles.buttonColor,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                _RegistrationStyles.fieldRadius,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'Continue',
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
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () =>
                        Scaffold(body: Center(child: LoadingAnimation())),
                    error: (error, stackTrace) {
                      return Center(
                        child: Text('$error'),
                      );
                    },
                  );
                },
              );
              // } else if (user.status == 'accepted') {
              //   return DetailsPage();
            } else if (_resolveUserStatus(user.status) == 'active') {
              log('im in active condition');
              return ProfileCompletionScreen();
            } else if (_resolveUserStatus(user.status) == 'inactive') {
              log('im in inactive condition');
              return const UserInactivePage();
            } else if (_resolveUserStatus(user.status) ==
                'subscription_expired') {
              log('im in subscription expired condition');
              return const SubcriptionExpiredPage();
            } else {
              log('im in payment condition');
              return const PaymentConfirmationPage();
            }
          },
          loading: () =>
              const Scaffold(body: Center(child: LoadingAnimation())),
          error: (error, stackTrace) {
            // Handle error state
            return LoginPage();
          },
        );
      },
    );
  }

  Widget _buildImagePickerOptions(
    BuildContext context,
  ) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Choose from Gallery'),
          onTap: () {
            Navigator.pop(context);
            _pickImage(ImageSource.gallery, context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Take a Photo'),
          onTap: () {
            Navigator.pop(context);
            _pickImage(ImageSource.camera, context);
          },
        ),
      ],
    );
  }
}

class _RegistrationStyles {
  static const Color subtitleColor = Color(0xFF757575);
  static const Color inputFill = Color(0xFFF7F2F1);
  static const Color hintColor = Color(0xFFB0A8A6);
  static const Color buttonColor = Color(0xFFC60E18);
  static const double horizontalPadding = 24.0;
  static const double fieldRadius = 12.0;
  static const double fieldHeight = 56.0;
  static const double buttonHeight = 56.0;
}

class _RegistrationTextField extends StatelessWidget {
  const _RegistrationTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: _RegistrationStyles.fieldHeight,
          child: TextFormField(
            controller: controller,
            validator: validator,
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1A1A1A),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _RegistrationStyles.hintColor,
              ),
              filled: true,
              fillColor: _RegistrationStyles.inputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RegistrationDropdown<T> extends StatelessWidget {
  const _RegistrationDropdown({
    required this.label,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
  });

  final String label;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: _RegistrationStyles.fieldHeight,
          child: DropdownButtonFormField2<T>(
            isExpanded: true,
            value: value,
            hint: Text(
              hint,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _RegistrationStyles.hintColor,
              ),
            ),
            items: items,
            onChanged: onChanged,
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF1A1A1A),
                size: 20,
              ),
            ),
            buttonStyleData: ButtonStyleData(
              height: _RegistrationStyles.fieldHeight,
              padding: const EdgeInsets.only(right: 12),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                color: Colors.white,
              ),
              elevation: 4,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: _RegistrationStyles.inputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(_RegistrationStyles.fieldRadius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
