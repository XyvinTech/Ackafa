import 'package:ackaf/src/data/services/api_routes/image_upload.dart';
import 'package:ackaf/src/interface/common/cards.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/demopage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/interface/common/customModalsheets.dart';
import 'package:ackaf/src/interface/common/customTextfields.dart';
import 'package:ackaf/src/interface/common/custom_switch.dart';
import 'package:ackaf/src/interface/common/components/svg_icon.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:ackaf/src/interface/screens/main_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';

class DetailsPage extends ConsumerStatefulWidget {
  const DetailsPage({super.key});

  @override
  ConsumerState<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  final isPhoneNumberVisibleProvider = StateProvider<bool>((ref) => false);

  final isLandlineVisibleProvider = StateProvider<bool>((ref) => false);

  final isContactDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isSocialDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isWebsiteDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isVideoDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isAwardsDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isProductsDetailsVisibleProvider = StateProvider<bool>((ref) => false);
  final isCertificateDetailsVisibleProvider =
      StateProvider<bool>((ref) => false);
  final isBrochureDetailsVisibleProvider = StateProvider<bool>((ref) => false);

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profilePictureController =
      TextEditingController();
  final TextEditingController personalPhoneController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();

  final TextEditingController designationController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController igController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController twtitterController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController websiteNameController = TextEditingController();
  final TextEditingController websiteLinkController = TextEditingController();
  final TextEditingController videoNameController = TextEditingController();
  final TextEditingController videoLinkController = TextEditingController();
  final TextEditingController awardNameController = TextEditingController();
  final TextEditingController awardAuthorityController =
      TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productMoqController = TextEditingController();
  final TextEditingController productActualPriceController =
      TextEditingController();
  final TextEditingController productOfferPriceController =
      TextEditingController();
  final TextEditingController certificateNameController =
      TextEditingController();
  final TextEditingController brochureNameController = TextEditingController();
  File? _profileImageFile;
  File? _companyImageFile;
  File? _awardImageFIle;
  File? _productImageFIle;
  File? _certificateImageFIle;
  File? _brochurePdfFile;

  final _formKey = GlobalKey<FormState>();
  ApiRoutes api = ApiRoutes();

  String productUrl = '';

  Future<File?> _pickFile({required String imageType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      if (imageType == 'profile') {
        setState(() {
          _profileImageFile = File(result.files.single.path!);
          imageUpload(Path.basename(_profileImageFile!.path),
                  _profileImageFile!.path)
              .then((url) {
            String profileUrl = url;
            ref.read(userProvider.notifier).updateProfilePicture(profileUrl);
            print((profileUrl));
          });
        });
        return _profileImageFile;
      } else if (imageType == 'award') {
        _awardImageFIle = File(result.files.single.path!);
        return _awardImageFIle;
      } else if (imageType == 'product') {
        _productImageFIle = File(result.files.single.path!);
        return _productImageFIle;
      } else if (imageType == 'certificate') {
        _certificateImageFIle = File(result.files.single.path!);
        return _certificateImageFIle;
      } else if (imageType == 'company') {
        setState(() {
          _companyImageFile = File(result.files.single.path!);
          imageUpload(Path.basename(_companyImageFile!.path),
                  _companyImageFile!.path)
              .then((url) {
            String companyUrl = url;
            ref.read(userProvider.notifier).updateCompany(Company(logo: url));
            final user = ref.watch(userProvider);
            user.whenData(
              (value) {
                log('company logo: ${value.company?.logo ?? ''}');
              },
            );

            print(companyUrl);
          });
        });
        return _companyImageFile;
      } else {
        _brochurePdfFile = File(result.files.single.path!);
        return _brochurePdfFile;
      }
    }
    return null;
  }

  // void _addAwardCard() async {
  // await api.createFileUrl(file: _awardImageFIle!).then((url) {
  //   awardUrl = url;
  //   print((awardUrl));
  // });
  //   ref.read(userProvider.notifier).updateAwards([...?ref.read(userProvider).value?.awards, newAward]);
  // }

  void _addNewAward() async {
    imageUpload(Path.basename(_awardImageFIle!.path), _awardImageFIle!.path)
        .then((url) {
      final String awardUrl = url;
      final newAward = Award(
        name: awardNameController.text,
        image: awardUrl,
        authority: awardAuthorityController.text,
      );

      ref
          .read(userProvider.notifier)
          .updateAwards([...?ref.read(userProvider).value?.awards, newAward]);
    });
  }

  void _removeAward(int index) async {
    await api
        .deleteFile(token, ref.read(userProvider).value!.awards![index].image!)
        .then(
          (value) => ref
              .read(userProvider.notifier)
              .removeAward(ref.read(userProvider).value!.awards![index]),
        );
  }

  void _addNewCertificate() async {
    imageUpload(Path.basename(_certificateImageFIle!.path),
            _certificateImageFIle!.path)
        .then((url) {
      final String certificateUrl = url;
      final newCertificate =
          Link(name: certificateNameController.text, link: certificateUrl);

      ref.read(userProvider.notifier).updateCertificate(
          [...?ref.read(userProvider).value?.certificates, newCertificate]);
    });
  }

  void _removeCertificate(int index) async {
    await api
        .deleteFile(
            token, ref.read(userProvider).value!.certificates![index].link!)
        .then((value) => ref.read(userProvider.notifier).removeCertificate(
            ref.read(userProvider).value!.certificates![index]));
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    bloodGroupController.dispose();
    emailController.dispose();
    profilePictureController.dispose();
    personalPhoneController.dispose();
    landlineController.dispose();
    companyPhoneController.dispose();

    designationController.dispose();
    companyNameController.dispose();
    companyEmailController.dispose();
    bioController.dispose();
    addressController.dispose();

    super.dispose();
  }

  Future<void> _submitData({required UserModel user}) async {
    String fullName =
        '${user.name!.first} ${user.name!.middle} ${user.name!.last}';

    List<String> nameParts = fullName.split(' ');

    String firstName = nameParts[0];
    String middleName = nameParts.length > 2 ? nameParts[1] : ' ';
    String lastName = nameParts.length > 1 ? nameParts.last : ' ';
    log('company logo:${user.company!.logo!}');

    final Map<String, dynamic> profileData = {
      "name": {
        "first": firstName,
        "middle": middleName,
        "last": lastName,
      },
      "email": user.email,
      "image": user.image,
      "college": user.college?.id,
      "course": user.course?.id,
      "address": user.address,
      "bio": user.bio,
      "company": {
        "name": user.company!.name ?? '',
        "designation": user.company!.designation ?? '',
        "phone": user.company!.phone ?? '',
        "address": user.company!.address ?? '',
        "logo": user.company!.logo ?? '',
      },
      "social": [
        for (var i in user.social!) {"name": "${i.name}", "link": i.link}
      ],
      "websites": [
        for (var i in user.websites!)
          {"name": i.name.toString(), "link": i.link}
      ],
      "videos": [
        for (var i in user.videos!) {"name": i.name, "link": i.link}
      ],
      "awards": [
        for (var i in user.awards!)
          {"name": i.name, "image": i.image, "authority": i.authority}
      ],
      "certificates": [
        for (var i in user.certificates!) {"name": i.name, "link": i.link}
      ],
    };
    await api.editUser(profileData);
    log(profileData.toString());
  }

  // Future<void> _selectImageFile(ImageSource source, String imageType) async {
  //   final XFile? image = await _picker.pickImage(source: source);
  //   print('$image');
  //   if (image != null && imageType == 'profile') {
  //     setState(() {
  //       _profileImageFile = _pickFile()
  //     });
  //   } else if (image != null && imageType == 'company') {
  //     setState(() {
  //       _companyImageFile = File(image.path);
  //     });
  //   }
  // }

  Future<void> _pickImage(ImageSource source, String imageType) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else if (source == ImageSource.gallery) {
      status = await Permission.photos.request();
    } else {
      return;
    }

    if (status.isGranted) {
      _pickFile(imageType: imageType);
    } else if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog(true);
    } else {
      _showPermissionDeniedDialog(false);
    }
  }

  void _showPermissionDeniedDialog(bool isPermanentlyDenied) {
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

  void _openModalSheet(
      {required String sheet, String brochureName = 'Sample'}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        if (sheet == 'award') {
          return ShowEnterAwardtSheet(
            pickImage: _pickFile,
            addAwardCard: _addNewAward,
            imageType: sheet,
            awardImage: _awardImageFIle,
            textController1: awardNameController,
            textController2: awardAuthorityController,
          );
        } else {
          return ShowAddCertificateSheet(
              certificateImage: _certificateImageFIle,
              addCertificateCard: _addNewCertificate,
              textController: certificateNameController,
              imageType: sheet,
              pickImage: _pickFile);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncUser = ref.watch(userProvider);

    final isSocialDetailsVisible = ref.watch(isSocialDetailsVisibleProvider);
    final isWebsiteDetailsVisible = ref.watch(isWebsiteDetailsVisibleProvider);
    final isVideoDetailsVisible = ref.watch(isVideoDetailsVisibleProvider);
    final isAwardsDetailsVisible = ref.watch(isAwardsDetailsVisibleProvider);

    final isCertificateDetailsVisible =
        ref.watch(isCertificateDetailsVisibleProvider);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: asyncUser.when(
            loading: () => Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              return Center(
                child: Text('Error loading User: $error '),
              );
            },
            data: (user) {
              print(user.name?.first);
              firstNameController.text = user.name!.first!;
              middleNameController.text = user.name!.middle ?? '';
              lastNameController.text = user.name!.last!;
              collegeController.text = user.college?.collegeName ?? '';
              batchController.text = user.batch.toString() ?? '';
              designationController.text = user.company?.designation ?? '';
              bioController.text = user.bio ?? '';
              companyPhoneController.text = user.company?.phone ?? '';
              companyNameController.text = user.company?.name ?? '';
              companyAddressController.text = user.company?.address ?? '';
              personalPhoneController.text = user.phone ?? '';
              emailController.text = user.email ?? '';
              addressController.text = user.address ?? '';
              List<TextEditingController> socialLinkControllers = [
                igController,
                linkedinController,
                twtitterController,
                facebookController
              ];

              for (int i = 0; i < socialLinkControllers.length; i++) {
                if (i < user.social!.length) {
                  socialLinkControllers[i].text = user.social![i].link ?? '';
                } else {
                  socialLinkControllers[i].clear();
                }
              }

              List<TextEditingController> websiteLinkControllers = [
                websiteLinkController
              ];
              List<TextEditingController> websiteNameControllers = [
                websiteNameController
              ];

              for (int i = 0; i < websiteLinkControllers.length; i++) {
                if (i < user.websites!.length) {
                  websiteLinkControllers[i].text = user.websites![i].link ?? '';
                  websiteNameControllers[i].text = user.websites![i].name ?? '';
                } else {
                  websiteLinkControllers[i].clear();
                  websiteNameControllers[i].clear();
                }
              }

              List<TextEditingController> videoLinkControllers = [
                videoLinkController
              ];
              List<TextEditingController> videoNameControllers = [
                videoNameController
              ];

              for (int i = 0; i < videoLinkControllers.length; i++) {
                if (i < user.videos!.length) {
                  videoLinkControllers[i].text = user.videos![i].link ?? '';
                  videoNameControllers[i].text = user.videos![i].name ?? '';
                } else {
                  videoLinkControllers[i].clear();
                  videoNameControllers[i].clear();
                }
              }

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: AppBar(
                              scrolledUnderElevation: 0,
                              backgroundColor: Colors.white,
                              elevation: 0,
                              leadingWidth: 100,
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.asset(
                                    'assets/icons/ackaf_logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MainPage()));
                                  },
                                  child: const Text(
                                    'Skip',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35),
                          FormField<File>(
                            validator: (value) {
                              if (user.image == null) {
                                return 'Please select a profile image';
                              }
                              return null;
                            },
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
                                              child: Image.network(
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Icon(Icons.person);
                                                },
                                                user.image!, // Replace with your image URL
                                                fit: BoxFit.cover,
                                              ),
                                            ),
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
                                                        context, 'profile'),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    offset: const Offset(2, 2),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                                shape: BoxShape.circle,
                                              ),
                                              child: const CircleAvatar(
                                                radius: 17,
                                                backgroundColor: Colors.white,
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
                                        padding: const EdgeInsets.only(top: 15),
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
                                      return 'Please Enter Your First Name';
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
                                  labelText: 'Enter your Middle name',
                                ),
                                const SizedBox(height: 20.0),
                                CustomTextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Your Last Name';
                                    }
                                    return null;
                                  },
                                  textController: lastNameController,
                                  labelText: 'Enter your Last name',
                                ),
                                const SizedBox(height: 20.0),
                                CustomTextFormField(
                                    readOnly: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Your Phone';
                                      }
                                      return null;
                                    },
                                    textController: personalPhoneController,
                                    labelText: 'Enter Your Phone'),
                                const SizedBox(height: 20.0),
                                CustomTextFormField(
                                    readOnly: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Select Your College';
                                      }
                                      return null;
                                    },
                                    textController: collegeController,
                                    labelText: 'Select Your College'),
                                const SizedBox(height: 20.0),
                                CustomTextFormField(
                                    readOnly: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Select Your Batch';
                                      }
                                      return null;
                                    },
                                    textController: batchController,
                                    labelText: 'Select Your Batch'),
                                const SizedBox(height: 20.0),
                                CustomTextFormField(
                                    readOnly: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Your Email';
                                      }
                                      return null;
                                    },
                                    textController: emailController,
                                    labelText: 'Enter Your Email'),
                                const SizedBox(height: 20.0),
                                CustomTextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Your Personal Address';
                                    }
                                    return null;
                                  },
                                  textController: addressController,
                                  labelText: 'Enter Personal Address',
                                  maxLines: 3,
                                  prefixIcon: const Icon(Icons.location_on,
                                      color: Color(0xFF004797)),
                                ),
                                const SizedBox(height: 20.0),
                                CustomTextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Your Bio';
                                      }
                                      return null;
                                    },
                                    textController: bioController,
                                    labelText: 'Bio',
                                    maxLines: 5),
                              ],
                            ),
                          ),
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 60, left: 16, bottom: 10),
                                child: Text(
                                  'Company Details',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          FormField<File>(
                            validator: (value) {
                              if (user.company?.logo == null) {
                                return 'Please select a company logo';
                              }
                              return null;
                            },
                            builder: (FormFieldState<File> state) {
                              return Center(
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        DottedBorder(
                                          radius: const Radius.circular(10),
                                          borderType: BorderType.RRect,
                                          dashPattern: [6, 3],
                                          color: Colors.grey,
                                          strokeWidth: 2,
                                          child: ClipRRect(
                                            child: Container(
                                              width: 110,
                                              height: 100,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              child: user.company?.logo != null
                                                  ? Image.network(
                                                      user.company!
                                                          .logo!, // Replace with your image URL
                                                      fit: BoxFit.cover,
                                                    )
                                                  : const Center(
                                                      child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Upload',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Company',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Logo',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -4,
                                          right: -4,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    _buildImagePickerOptions(
                                                        context, 'company'),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    offset:
                                                        const Offset(-1, -1),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                                shape: BoxShape.circle,
                                              ),
                                              child: const CircleAvatar(
                                                radius: 17,
                                                backgroundColor: Colors.white,
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
                                        padding: const EdgeInsets.only(top: 15),
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
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 10),
                            child: CustomTextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Your Company Designation';
                                  }
                                  return null;
                                },
                                labelText: 'Enter Company designation',
                                textController: designationController),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 10),
                            child: CustomTextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Company Name';
                                  }
                                  return null;
                                },
                                labelText: 'Enter Company Name',
                                textController: companyNameController),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: CustomTextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Your Company Phone';
                                }
                                return null;
                              },
                              labelText: 'Enter Company Phone',
                              textController: companyPhoneController,
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Color(0xFFE30613),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: CustomTextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Your Company Address (street, city, state, zip)';
                                }
                                return null;
                              },
                              labelText: 'Enter Company Address',
                              textController: companyAddressController,
                              maxLines: 3,
                              prefixIcon: const Icon(
                                Icons.location_city,
                                color: Color(0xFFE30613),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Social Media',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value:
                                      ref.watch(isSocialDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isSocialDetailsVisibleProvider
                                              .notifier)
                                          .state = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (isSocialDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: igController,
                                labelText: 'Enter Ig',
                                prefixIcon: const SvgIcon(
                                  assetName: 'assets/icons/instagram.svg',
                                  size: 10,
                                  color: Color(0xFFE30613),
                                ),
                              ),
                            ),
                          if (isSocialDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: linkedinController,
                                labelText: 'Enter Linkedin',
                                prefixIcon: const SvgIcon(
                                  assetName: 'assets/icons/linkedin.svg',
                                  color: Color(0xFFE30613),
                                  size: 10,
                                ),
                              ),
                            ),
                          if (isSocialDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: twtitterController,
                                labelText: 'Enter Twitter',
                                prefixIcon: const SvgIcon(
                                  assetName: 'assets/icons/twitter.svg',
                                  color: Color(0xFFE30613),
                                  size: 13,
                                ),
                              ),
                            ),
                          if (isSocialDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: facebookController,
                                labelText: 'Enter Facebook',
                                prefixIcon: const Icon(
                                  Icons.facebook,
                                  color: Color(0xFFE30613),
                                  size: 28,
                                ),
                              ),
                            ),
                          if (isSocialDetailsVisible)
                            const Padding(
                              padding: EdgeInsets.only(right: 20, bottom: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Add more',
                                    style: TextStyle(
                                        color: Color(0xFFE30613),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: Color(0xFFE30613),
                                    size: 18,
                                  )
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Add Website',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value: ref
                                      .watch(isWebsiteDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isWebsiteDetailsVisibleProvider
                                              .notifier)
                                          .state = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (isWebsiteDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: CustomTextFormField(
                                textController: websiteLinkController,
                                readOnly: true,
                                labelText: 'Enter Website Link',
                                suffixIcon: const Icon(
                                  Icons.add,
                                  color: Color(0xFFE30613),
                                ),
                                onTap: () {
                                  showWlinkorVlinkSheet(
                                      textController1: websiteNameController,
                                      textController2: websiteLinkController,
                                      fieldName: 'Add Website Link',
                                      title: 'Add Website',
                                      context: context);
                                },
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Add Video Link',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value:
                                      ref.watch(isVideoDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isVideoDetailsVisibleProvider
                                              .notifier)
                                          .state = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (isVideoDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 70),
                              child: CustomTextFormField(
                                textController: videoLinkController,
                                readOnly: true,
                                onTap: () {
                                  showWlinkorVlinkSheet(
                                      textController1: videoNameController,
                                      textController2: videoLinkController,
                                      fieldName: 'Add Youtube Link',
                                      title: 'Add Video Link',
                                      context: context);
                                },
                                labelText: 'Enter Video Link',
                                suffixIcon: const Icon(
                                  Icons.add,
                                  color: Color(0xFFE30613),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Enter Awards',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value:
                                      ref.watch(isAwardsDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    ref
                                        .read(isAwardsDetailsVisibleProvider
                                            .notifier)
                                        .state = value;

                                    // if (value == false) {
                                    //   setState(
                                    //     () {
                                    //       awards = [];
                                    //     },
                                    //   );
                                    // }
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (isAwardsDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, bottom: 10, right: 10),
                              child: GridView.builder(
                                shrinkWrap:
                                    true, // Let GridView take up only as much space as it needs
                                physics:
                                    NeverScrollableScrollPhysics(), // Disable GridView's internal scrolling
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of columns
                                  crossAxisSpacing:
                                      8.0, // Space between columns
                                  mainAxisSpacing: 8.0, // Space between rows
                                  childAspectRatio:
                                      .9, // Aspect ratio for the cards
                                ),
                                itemCount: user.awards!.length,
                                itemBuilder: (context, index) {
                                  return AwardCard(
                                    award: user.awards![index],
                                    onRemove: () => _removeAward(index),
                                  );
                                },
                              ),
                            ),
                          if (isAwardsDetailsVisible)
                            GestureDetector(
                              onTap: () {
                                _openModalSheet(
                                  sheet: 'award',
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, bottom: 60),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Color(0xFFE30613),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Enter Awards',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Enter Certificates',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value: ref.watch(
                                      isCertificateDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(
                                              isCertificateDetailsVisibleProvider
                                                  .notifier)
                                          .state = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (user.certificates!.isNotEmpty &&
                              isCertificateDetailsVisible)
                            ListView.builder(
                              shrinkWrap:
                                  true, // Let ListView take up only as much space as it needs
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable ListView's internal scrolling
                              itemCount: user.certificates!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0), // Space between items
                                  child: CertificateCard(
                                    certificate: user.certificates![index],
                                    onRemove: () => _removeCertificate(index),
                                  ),
                                );
                              },
                            ),
                          if (isCertificateDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, bottom: 60),
                              child: GestureDetector(
                                onTap: () =>
                                    _openModalSheet(sheet: 'certificate'),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Color(0xFFE30613),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Enter Certificates',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 60),
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
                              label: 'Save & Proceed',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _submitData(user: user);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Success')),
                                  );
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MainPage()));
                                }
                              }))),
                ],
              );
            },
          )),
    );
  }

  Widget _buildImagePickerOptions(BuildContext context, String imageType) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Choose from Gallery'),
          onTap: () {
            Navigator.pop(context);
            _pickImage(ImageSource.gallery, imageType);
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
