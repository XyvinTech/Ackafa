import 'dart:developer';
import 'dart:io';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/college_model.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/providers/loading_notifier.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/api_routes/college_api.dart';
import 'package:ackaf/src/data/services/api_routes/image_upload.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:ackaf/src/interface/common/customTextfields.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/custom_dropdowns/custom_dropdowns.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPage.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/paymentpage.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/profile_completetion_page.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/subcription_expired_page.dart';

import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_inactive_page.dart';
import 'package:ackaf/src/interface/validatelinks.dart';
import 'package:dotted_border/dotted_border.dart';
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
  final TextEditingController emirateIDController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
  Course? selectedCourse;
  String? selectedCollegeId;
  String? selectedCourseId;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return asyncUser.when(
          data: (user) {
            if (user.batch == null) {
              return Consumer(
                builder: (context, ref, child) {
                  final asyncColleges = ref.watch(fetchCollegesProvider(token));
                  return asyncColleges.when(
                    data: (colleges) {
                      return RefreshIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.red,
                        onRefresh: () async => ref.invalidate(userProvider),
                        child: Scaffold(
                            backgroundColor: Colors.white,
                            body: Stack(
                              children: [
                                SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 105),
                                        FormField<File>(
                                          // validator: (value) {
                                          //   if (_profileImageFile == null) {
                                          //     log(profileImageUrl ??
                                          //         'No profile image selected');
                                          //     return 'Please select a profile image';
                                          //   }
                                          //   return null;
                                          // },
                                          builder:
                                              (FormFieldState<File> state) {
                                            return Center(
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      DottedBorder(
                                                        borderType:
                                                            BorderType.Circle,
                                                        dashPattern: [6, 3],
                                                        color: Colors.grey,
                                                        strokeWidth: 2,
                                                        child: ClipOval(
                                                          child: Container(
                                                              width: 120,
                                                              height: 120,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255),
                                                              child: _profileImageFile !=
                                                                      null
                                                                  ? Image.file(
                                                                      _profileImageFile!,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : const Icon(
                                                                      Icons
                                                                          .person,
                                                                      size: 50,
                                                                    )),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 4,
                                                        right: 4,
                                                        child: InkWell(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              builder: (context) =>
                                                                  _buildImagePickerOptions(
                                                                context,
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2),
                                                                  offset:
                                                                      const Offset(
                                                                          2, 2),
                                                                  blurRadius: 4,
                                                                ),
                                                              ],
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child:
                                                                const CircleAvatar(
                                                              radius: 17,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: Color(
                                                                    0xFFE30613),
                                                                size: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (state.hasError)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15),
                                                      child: Text(
                                                        state.errorText ?? '',
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        const Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 60,
                                                  left: 16,
                                                  bottom: 10),
                                              child: Text(
                                                'Personal Details',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 10,
                                              bottom: 10),
                                          child: Column(
                                            children: [
                                              _createLabel('Full Name', true),
                                              CustomTextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Enter your Full Name';
                                                  }
                                                  return null;
                                                },
                                                textController: nameController,
                                                labelText:
                                                    'Enter Your Full name',
                                              ),
                                              const SizedBox(height: 20.0),
                                              _createLabel('Email ID', true),
                                              CustomTextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please Enter your Email ID';
                                                    }
                                                    return null;
                                                  },
                                                  textController:
                                                      emailController,
                                                  labelText:
                                                      'Enter your  Email ID'),
                                              const SizedBox(height: 20.0),
                                              _createLabel('Emirates ID', true),
                                              CustomTextFormField(
                                                  validator: (value) =>
                                                      validateEmiratesId(value,
                                                          phoneNumber:
                                                              user.phone ?? ''),
                                                  textController:
                                                      emirateIDController,
                                                  labelText:
                                                      'Enter your  Emirates ID'),
                                              const SizedBox(height: 20.0),
                                              _createLabel('College', true),
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
                                                      CustomDropdownButton<
                                                          College>(
                                                        labelText:
                                                            'Select College',
                                                        items: colleges
                                                            .map((college) {
                                                          return DropdownMenuItem<
                                                              College>(
                                                            value:
                                                                college, // Store the entire College object as value
                                                            child: Text(college
                                                                .collegeName!),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (College? value) {
                                                          setState(() {
                                                            selectedCollege =
                                                                value;
                                                            selectedCollegeIndex =
                                                                colleges.indexWhere(
                                                                    (college) =>
                                                                        college
                                                                            .id ==
                                                                        value
                                                                            ?.id);
                                                            selectedCollegeId =
                                                                value?.id;
                                                            state.didChange(
                                                                value); // Notify the form field of the change
                                                          });
                                                        },
                                                      ),
                                                      if (state.hasError)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                          child: Text(
                                                            state.errorText!,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 20.0),
                                              _createLabel('Batch', true),
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
                                                      CustomDropdownButton<
                                                          String>(
                                                        labelText:
                                                            'Select Batch',
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
                                                                  child: Text(batch
                                                                      .toString()),
                                                                );
                                                              }).toList()
                                                            : [],
                                                        value: selectedBatch,
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            selectedBatch =
                                                                value;
                                                            state.didChange(
                                                                value); // Notify the form field of the change
                                                          });
                                                        },
                                                      ),
                                                      if (state.hasError)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                          child: Text(
                                                            state.errorText!,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 90),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 20,
                                    left: 20,
                                    right: 20,
                                    child: SizedBox(
                                        height: 50,
                                        child: customButton(
                                            fontSize: 16,
                                            label: user.status == 'inactive'
                                                ? 'Send Request'
                                                : 'Next',
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                try {
                                                  if (_profileImageFile !=
                                                          null &&
                                                      _profileImageFile != '') {
                                                    profileImageUrl =
                                                        await imageUpload(
                                                            _profileImageFile!
                                                                .path);
                                                  }

                                                  print(profileImageUrl);
                                                  log(token);

                                                  final response = await userApi
                                                      .registerUser(
                                                          emiratesID:
                                                              emirateIDController
                                                                  .text,
                                                          token: token,
                                                          profileUrl:
                                                              profileImageUrl,
                                                          name:
                                                              nameController
                                                                  .text,
                                                          emailId:
                                                              emailController
                                                                  .text,
                                                          college:
                                                              selectedCollegeId,
                                                          batch: selectedBatch,
                                                          context: context);

                                                  if (response) {
                                                    log('user status: ${user.status}');
                                                    if (user.status ==
                                                        'active') {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ProfileCompletionScreen()));
                                                    } else if (user.status ==
                                                        'awaiting_payment') {
                                                      log('im in payment condition ok');
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const PaymentConfirmationPage()));
                                                    } else {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const UserInactivePage()));
                                                    }
                                                  }
                                                } catch (e) {
                                                  CustomSnackbar.showSnackbar(
                                                      context, '$e');
                                                }
                                              }
                                            }))),
                              ],
                            )),
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
            } else if (user.status == 'active') {
              log('im in active condition');
              return ProfileCompletionScreen();
            } else if (user.status == 'inactive') {
              log('im in inactive condition');
              return const UserInactivePage();
            } else if (user.status == 'subscription_expired') {
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

  Widget _createLabel(String label, bool isMandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 5,
            ),
            if (isMandatory)
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
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
