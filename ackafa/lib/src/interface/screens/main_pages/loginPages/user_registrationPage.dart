import 'dart:io';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/college_model.dart';
import 'package:ackaf/src/data/services/api_routes/college_api.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/customTextfields.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/custom_dialog.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minio_flutter/io.dart';
import 'package:minio_flutter/minio.dart';
import 'package:path/path.dart'as Path;
import 'package:permission_handler/permission_handler.dart';

class UserDetailsScreen extends StatefulWidget {
  final VoidCallback onNext;
  const UserDetailsScreen({super.key, required this.onNext});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  File? _profileImageFile;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  Future<void> _pickImage(ImageSource source, context) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else if (source == ImageSource.gallery) {
      status = await Permission.photos.request();
    } else {
      return;
    }

    if (status.isGranted) {
      _pickFile();
    } else if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog(true, context);
    } else {
      _showPermissionDeniedDialog(false, context);
    }
  }

  Future<File?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        _profileImageFile = File(result.files.single.path!);
        // api.createFileUrl(file: _profileImageFile!, token: token).then((url) {
        //   String profileUrl = url;
        //   ref.read(userProvider.notifier).updateProfilePicture(profileUrl);
        //   print((profileUrl));
        // });
      });
      return _profileImageFile;
    }
    return null;
  }

  void _showPermissionDeniedDialog(bool isPermanentlyDenied, context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: Text(isPermanentlyDenied
              ? 'Permission is permanently denied. Please enable it from the app settings.'
              : 'Permission is denied. Please grant the permission to proceed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isPermanentlyDenied) {
                  openAppSettings();
                }
              },
              child: Text(isPermanentlyDenied ? 'Open Settings' : 'OK'),
            ),
          ],
        );
      },
    );
  }

  int? selectedCollegeIndex = -1;
  String? profileImageUrl;
  College? selectedCollege;
  String? selectedBatch;
  Course? selectedCourse;
  String? selectedCollegeId;
  String? selectedCourseId;

  @override
  Widget build(BuildContext context) {
    Minio.init(
      endPoint: 's3.amazonaws.com',
      accessKey: dotenv.env['AWS_ACCESS_KEY_ID']!,
      secretKey: dotenv.env['AWS_SECRET_ACCESS_KEY']!,
      region: 'ap-south-1',
    );
    return SafeArea(
      child: Consumer(
        builder: (context, ref, child) {
          final asyncColleges = ref.watch(fetchCollegesProvider(token));
          return asyncColleges.when(
            data: (colleges) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Form(
                          child: Column(
                            children: [
                              const SizedBox(height: 35),
                              FormField<File>(
                                validator: (value) {},
                                builder: (FormFieldState<File> state) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            DottedBorder(
                                              borderType: BorderType.Circle,
                                              dashPattern: [6, 3],
                                              color: Colors.grey,
                                              strokeWidth: 2,
                                              child: ClipOval(
                                                child: Container(
                                                    width: 120,
                                                    height: 120,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    child: _profileImageFile !=
                                                            null
                                                        ? Image.file(
                                                            _profileImageFile!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Icon(
                                                            Icons.person,
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
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        offset:
                                                            const Offset(2, 2),
                                                        blurRadius: 4,
                                                      ),
                                                    ],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const CircleAvatar(
                                                    radius: 17,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Color(0xFFE30613),
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
                                                const EdgeInsets.only(top: 15),
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
                                        top: 60, left: 16, bottom: 10),
                                    child: Text(
                                      'Personal Details',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    CustomTextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Enter your First Name';
                                        }
                                        return null;
                                      },
                                      textController: firstNameController,
                                      labelText: 'Enter your First name',
                                    ),
                                    const SizedBox(height: 20.0),
                                    CustomTextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter your Middle name';
                                          }
                                          return null;
                                        },
                                        textController: middleNameController,
                                        labelText: 'Enter your Middle name'),
                                    const SizedBox(height: 20.0),
                                    CustomTextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter your Last name';
                                          }
                                          return null;
                                        },
                                        textController: lastNameController,
                                        labelText: 'Enter your Last name'),
                                    const SizedBox(height: 20.0),
                                    CustomTextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter your Email ID';
                                          }
                                          return null;
                                        },
                                        textController: emailController,
                                        labelText: 'Enter your  Email ID'),
                                    const SizedBox(height: 20.0),
                                    CustomDropdownButton(
                                      labelText: 'Select College',
                                      items: colleges.map((college) {
                                        return DropdownMenuItem<College>(
                                          value:
                                              college, // Store the entire College object as value
                                          child: Text(college.collegeName!),
                                        );
                                      }).toList(),
                                      onChanged: (College? value) {
                                        print(
                                            'Selected College: ${value?.collegeName}, ID: ${value?.id}');
                                        setState(() {
                                          selectedCollege = value;
                                          selectedCollegeIndex =
                                              colleges.indexWhere((college) =>
                                                  college.id == value?.id);
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20.0),
                                    CustomDropdownButton<String>(
                                      labelText: 'Select Batch',
                                      items: selectedCollegeIndex != -1
                                          ? colleges[selectedCollegeIndex!]
                                              .batch!
                                              .map((batch) {
                                              return DropdownMenuItem<String>(
                                                value: batch.toString(),
                                                child: Text(batch.toString()),
                                              );
                                            }).toList()
                                          : [],
                                      value: selectedBatch,
                                      onChanged: (String? value) {
                                        selectedBatch = value;
                                        print('Selected Batch: $value');
                                      },
                                    ),
                                    const SizedBox(height: 20.0),
                                    CustomDropdownButton<Course>(
                                      labelText: 'Select Course',
                                      items: selectedCollegeIndex != -1
                                          ? colleges[selectedCollegeIndex!]
                                              .course!
                                              .map((course) {
                                              return DropdownMenuItem<Course>(
                                                value:
                                                    course, // Store the entire Course object as value
                                                child: Text(course.courseName
                                                    .toString()),
                                              );
                                            }).toList()
                                          : [],
                                      value: selectedCourse,
                                      onChanged: (Course? value) {
                                        selectedCourse =
                                            value; // Update the selected course
                                        selectedCollegeId = value?.id;
                                        print(
                                            'Selected Course ID: ${value?.id}');
                                      },
                                    )
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
                                  label: 'Send Request',
                                  onPressed: () async {
                                    ApiRoutes userApi = ApiRoutes();
                                    await Minio.shared.fPutObject(
                                        'akcaf',
                                       Path.basename(_profileImageFile!.path),
                                        _profileImageFile!.path);
                                    print(
                                        "https://akcaf.s3.ap-south-1.amazonaws.com/${Path.basename(_profileImageFile!.path)}");
                                    profileImageUrl =
                                        "https://akcaf.s3.ap-south-1.amazonaws.com/${Path.basename(_profileImageFile!.path)}";

                                    final respone = userApi.updateUser(
                                        token: token,
                                        profileUrl: profileImageUrl,
                                        firstName: firstNameController.text,
                                        middleName: middleNameController.text,
                                        lastName: lastNameController.text,
                                        emailId: emailController.text,
                                        college: selectedCollegeId,
                                        batch: selectedBatch,
                                        course: selectedCourseId,
                                        context: context);
                                    if (await respone) {
                                      showCustomDialog(context);
                                      widget.onNext();
                                    }
                                  }))),
                    ],
                  ));
            },
            loading: () => Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              return Center(
                child: Text('$error'),
              );
            },
          );
        },
      ),
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
        // ListTile(
        //   leading: const Icon(Icons.camera_alt),
        //   title: const Text('Take a Photo'),
        //   onTap: () {
        //     Navigator.pop(context);
        //     _pickImage(ImageSource.camera, imageType);
        //   },
        // ),
      ],
    );
  }
}
