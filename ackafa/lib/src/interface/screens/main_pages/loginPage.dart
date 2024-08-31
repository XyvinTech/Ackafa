import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/customTextfields.dart';
import 'package:kssia/src/interface/common/custom_switch.dart';
import 'package:kssia/src/interface/common/components/svg_icon.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/main_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
          OTPScreen(onNext: _nextPage),
          ProfileCompletionScreen(onNext: _nextPage),
          const DetailsPage(),
        ],
      ),
    );
  }
}

class PhoneNumberScreen extends StatelessWidget {
  final VoidCallback onNext;

  const PhoneNumberScreen({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '1', model: 'mobile'),
                    _buildbutton(label: '3', model: 'mobile'),
                    _buildbutton(label: '3', model: 'mobile')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '4', model: 'mobile'),
                    _buildbutton(label: '5', model: 'mobile'),
                    _buildbutton(label: '6', model: 'mobile')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '7', model: 'mobile'),
                    _buildbutton(label: '8', model: 'mobile'),
                    _buildbutton(label: '9', model: 'mobile')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      onPressed: () async {
                        if (_mobileController.text.length != 10) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Please Enter Valid Phone number')));
                        }
                        ApiRoutes userApi = ApiRoutes();
                        String? response = await userApi.sendOtp(
                            _mobileController.text, context);
                        if (response != null) {
                          onNext();
                        }

                        final SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setString(
                            'mobile', _mobileController.text.toString());
                      },
                      fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  final VoidCallback onNext;
  OTPScreen({required this.onNext});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
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
    // Add your resend code logic here
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/icons/kssiaLogo.png',
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
                _isButtonDisabled ? 'Resend Code in $_start s' : 'Resend Code',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '1', model: 'otp'),
                    _buildbutton(label: '2', model: 'otp'),
                    _buildbutton(label: '3', model: 'otp')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '4', model: 'otp'),
                    _buildbutton(label: '5', model: 'otp'),
                    _buildbutton(label: '6', model: 'otp')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: '7', model: 'otp'),
                    _buildbutton(label: '8', model: 'otp'),
                    _buildbutton(label: '9', model: 'otp')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildbutton(label: 'ABC', model: ''),
                    _buildbutton(label: '0', model: 'otp'),
                    _buildbutton(
                        label: 'back',
                        icondata: Icons.arrow_back_ios,
                        model: 'otp')
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
                      label: 'NEXT',
                      onPressed: () async {
                        print(_otpController.text);
                        ApiRoutes userApi = ApiRoutes();
                        List<dynamic> credentials = await userApi.verifyUser(
                            _mobileController.text,
                            _otpController.text,
                            context);
                        final SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        if (credentials.isNotEmpty) {
                          preferences.setString(
                              'token', credentials[0]['token']!);
                          preferences.setString(
                              'id', credentials[0]['userId']!);
                          token = preferences.getString('token')!;
                          id = preferences.getString('id')!;
                          widget.onNext();
                          _mobileController.clear();
                          _otpController.clear();
                        }
                      },
                      fontSize: 16)),
            ),
          ],
        ),
      ),
    );
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
          width: 100,
          child: DecoratedBox(
              decoration: const BoxDecoration(),
              child: Center(
                  child: icondata != null
                      ? Icon(icondata,
                          size: 19,
                          color: const Color.fromARGB(255, 139, 138, 138))
                      : Text(
                          label,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                              color: Color.fromARGB(255, 117, 116, 116)),
                        ))),
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

class ProfileCompletionScreen extends StatelessWidget {
  final VoidCallback onNext;

  ProfileCompletionScreen({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace SvgPicture.asset with any image you are using
            Image.asset('assets/letsgetstarted.png', width: 150),

            const Text(
              "Let's Get Started,\nComplete your profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 118, 121, 124),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: customButton(
                      label: 'Next', onPressed: onNext, fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainPage()));
              },
              child: const Text('Skip',
                  style: TextStyle(color: Colors.black, fontSize: 15)),
            )
          ],
        ),
      ),
    );
  }
}



class DetailsPage extends ConsumerStatefulWidget {
  const DetailsPage({super.key});

  @override
  ConsumerState<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  String _productPriceType = 'Price per unit';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profilePictureController =
      TextEditingController();
  final TextEditingController personalPhoneController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController whatsappBusinessController =
      TextEditingController();
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
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      if (imageType == 'profile') {
        setState(() {
          _profileImageFile = File(result.files.single.path!);
          api.createFileUrl(file: _profileImageFile!, token: token).then((url) {
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
          api.createFileUrl(file: _companyImageFile!, token: token).then((url) {
            String companyUrl = url;
            ref.read(userProvider.notifier).updateCompanyLogo(companyUrl);
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
    await api.createFileUrl(file: _awardImageFIle!, token: token).then((url) {
      final String awardUrl = url;
      final newAward = Award(
        name: awardNameController.text,
        url: awardUrl,
        authorityName: awardAuthorityController.text,
      );

      ref
          .read(userProvider.notifier)
          .updateAwards([...?ref.read(userProvider).value?.awards, newAward]);
    });
  }

  void _removeAward(int index) async {
    await api
        .deleteFile(token, ref.read(userProvider).value!.awards![index].url!)
        .then(
          (value) => ref
              .read(userProvider.notifier)
              .removeAward(ref.read(userProvider).value!.awards![index]),
        );
  }

  _addNewProduct() async {
    final createdProduct = await api.uploadProduct(
        token,
        productNameController.text,
        productActualPriceController.text,
        productDescriptionController.text,
        productMoqController.text,
        _productImageFIle!,
        id);
    if (createdProduct == null) {
      print('couldnt create new product');
    } else {
      productUrl =
          await api.createFileUrl(file: _productImageFIle!, token: token);
      final newProduct = Product(
        id: createdProduct.id,
        name: productNameController.text,
        image: productUrl,
        description: productDescriptionController.text,
        moq: int.parse(productMoqController.text),
        offerPrice: int.parse(productOfferPriceController.text),
        price: int.parse(productActualPriceController.text),
        sellerId: SellerId(id: id),
        status: true,
      );
      ref.read(userProvider.notifier).updateProduct(
          [...?ref.read(userProvider).value?.products, newProduct]);
    }
  }

  void _removeProduct(int index) async {
    await api
        .deleteFile(
            token, ref.read(userProvider).value!.products![index].image!)
        .then((value) => ref
            .read(userProvider.notifier)
            .removeProduct(ref.read(userProvider).value!.products![index]));
  }

  void _addNewCertificate() async {
    await api
        .createFileUrl(file: _certificateImageFIle!, token: token)
        .then((url) {
      final String certificateUrl = url;
      final newCertificate = Certificate(
          name: certificateNameController.text, url: certificateUrl);

      ref.read(userProvider.notifier).updateCertificate(
          [...?ref.read(userProvider).value?.certificates, newCertificate]);
    });
  }

  void _removeCertificate(int index) async {
    await api
        .deleteFile(
            token, ref.read(userProvider).value!.certificates![index].url!)
        .then((value) => ref.read(userProvider.notifier).removeCertificate(
            ref.read(userProvider).value!.certificates![index]));
  }

  void _addNewBrochure() async {
    await api.createFileUrl(file: _brochurePdfFile!, token: token).then((url) {
      final String brochureUrl = url;
      final newBrochure =
          Brochure(name: brochureNameController.text, url: brochureUrl);

      ref.read(userProvider.notifier).updateBrochure(
          [...?ref.read(userProvider).value?.brochure, newBrochure]);
    });
  }

  void _removeBrochure(int index) async {
    await api
        .deleteFile(
            token, ref.read(userProvider).value!.certificates![index].url!)
        .then((value) => ref.read(userProvider.notifier).removeCertificate(
            ref.read(userProvider).value!.certificates![index]));
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    nameController.dispose();
    bloodGroupController.dispose();
    emailController.dispose();
    profilePictureController.dispose();
    personalPhoneController.dispose();
    landlineController.dispose();
    companyPhoneController.dispose();
    whatsappController.dispose();
    whatsappBusinessController.dispose();
    designationController.dispose();
    companyNameController.dispose();
    companyEmailController.dispose();
    bioController.dispose();
    addressController.dispose();

    super.dispose();
  }

  Future<void> _submitData({required User user}) async {
    String fullName =
        '${user.name!.firstName} ${user.name!.middleName} ${user.name!.lastName}';

    List<String> nameParts = fullName.split(' ');

    String firstName = nameParts[0];
    String middleName = nameParts.length > 2 ? nameParts[1] : ' ';
    String lastName = nameParts.length > 1 ? nameParts.last : ' ';

    final Map<String, dynamic> profileData = {
      "name": {
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
      },
      "blood_group": user.bloodGroup,
      "email": user.email,
      "profile_picture": user.profilePicture,
      "phone_numbers": {
        "personal": user.phoneNumbers!.personal ?? 0,
        "landline": user.phoneNumbers!.landline ?? 0,
        "company_phone_number": user.phoneNumbers!.companyPhoneNumber ?? 0,
        "whatsapp_number": user.phoneNumbers!.whatsappNumber ?? 0,
        "whatsapp_business_number":
            user.phoneNumbers!.whatsappBusinessNumber ?? 0,
      },
      "designation": user.designation,
      "company_logo": user.companyLogo,
      "company_name": user.companyName,
      "company_email": user.companyEmail,
      "company_address": user.companyAddress,
      "bio": user.bio,
      "address": user.address,
      "social_media": [
        for (var i in user.socialMedia!)
          {"platform": "${i.platform}", "url": i.url}
      ],
      "websites": [
        for (var i in user.websites!) {"name": i.name.toString(), "url": i.url}
      ],
      "video": [
        for (var i in user.video!) {"name": i.name, "url": i.url}
      ],
      "awards": [
        for (var i in user.awards!)
          {"name": i.name, "url": i.url, "authority_name": i.authorityName}
      ],
      "certificates": [
        for (var i in user.certificates!) {"name": i.name, "url": i.url}
      ],
      "brochure": [
        for (var i in user.brochure!) {"name": i.name, "url": i.url}
      ],
      "products": [
        for (var i in user.products!)
          {
            "_id": i.id,
            "seller_id": i.sellerId,
            "name": i.name,
            "image": i.image,
            "price": i.price,
            "offer_price": i.offerPrice,
            "description": i.description,
            "moq": i.moq ?? 0,
            "units": i.units ?? 0,
            "status": i.status,
            "tags": ["string"]
          }
      ]
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
        } else if (sheet == 'product') {
          return ShowEnterProductsSheet(
              productImage: _productImageFIle,
              imageType: sheet,
              pickImage: _pickFile,
              addProductCard: _addNewProduct,
              productNameText: productNameController,
              descriptionText: productDescriptionController,
              moqText: productMoqController,
              actualPriceText: productActualPriceController,
              offerPriceText: productOfferPriceController,
              productPriceType: _productPriceType);
        } else if (sheet == 'certificate') {
          return ShowAddCertificateSheet(
              certificateImage: _certificateImageFIle,
              addCertificateCard: _addNewCertificate,
              textController: certificateNameController,
              imageType: sheet,
              pickImage: _pickFile);
        } else {
          return ShowAddBrochureSheet(
              brochureName: brochureName,
              textController: brochureNameController,
              pickPdf: _pickFile,
              imageType: sheet,
              addBrochureCard: _addNewBrochure);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncUser = ref.watch(userProvider);
    final isPhoneNumberVisible = ref.watch(isPhoneNumberVisibleProvider);
    final isContactDetailsVisible = ref.watch(isContactDetailsVisibleProvider);
    final isSocialDetailsVisible = ref.watch(isSocialDetailsVisibleProvider);
    final isWebsiteDetailsVisible = ref.watch(isWebsiteDetailsVisibleProvider);
    final isVideoDetailsVisible = ref.watch(isVideoDetailsVisibleProvider);
    final isAwardsDetailsVisible = ref.watch(isAwardsDetailsVisibleProvider);
    final isLandlineVisible = ref.watch(isLandlineVisibleProvider);
    final isProductsDetailsVisible =
        ref.watch(isProductsDetailsVisibleProvider);
    final isCertificateDetailsVisible =
        ref.watch(isCertificateDetailsVisibleProvider);
    final isBrochureDetailsVisible =
        ref.watch(isBrochureDetailsVisibleProvider);

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
              print(user.awards);
              nameController.text =
                  '${user.name!.firstName} ${user.name!.middleName} ${user.name!.lastName}';
              designationController.text = user.designation!;
              bioController.text = user.bio!;
              companyNameController.text = user.companyName!;
              companyAddressController.text = user.companyAddress!;
              personalPhoneController.text =
                  user.phoneNumbers!.personal.toString();
              landlineController.text = user.phoneNumbers!.landline.toString();
              emailController.text = user.email!;
              whatsappBusinessController.text =
                  user.phoneNumbers!.whatsappBusinessNumber == 0
                      ? ''
                      : user.phoneNumbers!.whatsappBusinessNumber.toString();
              whatsappController.text = user.phoneNumbers!.whatsappNumber == 0
                  ? ''
                  : user.phoneNumbers!.whatsappNumber.toString();
              addressController.text = user.address!;
              List<TextEditingController> socialLinkControllers = [
                igController,
                linkedinController,
                twtitterController,
                facebookController
              ];

              for (int i = 0; i < socialLinkControllers.length; i++) {
                if (i < user.socialMedia!.length) {
                  socialLinkControllers[i].text =
                      user.socialMedia![i].url ?? '';
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
                  websiteLinkControllers[i].text = user.websites![i].url ?? '';
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
                if (i < user.video!.length) {
                  videoLinkControllers[i].text = user.video![i].url ?? '';
                  videoNameControllers[i].text = user.video![i].name ?? '';
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
                                    'assets/icons/kssiaLogo.png',
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
                              if (user.profilePicture == null) {
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
                                                user.profilePicture!, // Replace with your image URL
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
                                      return 'Please Enter Your Full Name';
                                    }
                                    return null;
                                  },
                                  textController: nameController,
                                  labelText: 'Enter your Full name',
                                ),
                                const SizedBox(height: 20.0),
                                CustomTextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Your Designation';
                                      }
                                      return null;
                                    },
                                    textController: designationController,
                                    labelText: 'Designation'),
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
                          const Padding(
                            padding: EdgeInsets.only(right: 20),
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
                              if (user.companyLogo == null) {
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
                                              child: Image.network(
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Center(
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
                                                  ));
                                                },
                                                user.companyLogo!, // Replace with your image URL
                                                fit: BoxFit.cover,
                                              ),
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
                                    return 'Please Enter Your Company Name';
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
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Phone Number',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value:
                                      ref.watch(isPhoneNumberVisibleProvider),
                                  onChanged: (bool value) {
                                    ref
                                        .read(isPhoneNumberVisibleProvider
                                            .notifier)
                                        .state = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (isPhoneNumberVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 0, bottom: 10),
                              child: CustomTextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Your Phone Number';
                                  }
                                  return null;
                                },
                                textController: personalPhoneController,
                                labelText: 'Enter phone number',
                                prefixIcon: const Icon(Icons.phone,
                                    color: Color(0xFFE30613)),
                              ),
                            ),
                          if (isPhoneNumberVisible && !isLandlineVisible)
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, bottom: 50),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ref
                                        .read(
                                            isLandlineVisibleProvider.notifier)
                                        .state = !isLandlineVisible;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (isPhoneNumberVisible && isLandlineVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 20),
                              child: CustomTextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Your Landline Number';
                                  }
                                  return null;
                                },
                                textController: landlineController,
                                labelText: 'Enter landline number',
                                prefixIcon: const Icon(Icons.phone_in_talk,
                                    color: Color(0xFFE30613)),
                              ),
                            ),
                          if (isContactDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 0, bottom: 10),
                              child: CustomTextFormField(
                                textController: emailController,
                                labelText: 'Enter Email',
                                prefixIcon: const Icon(Icons.email,
                                    color: Color(0xFFE30613)),
                              ),
                            ),
                          if (isContactDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: whatsappBusinessController,
                                labelText: 'Enter Business Whatsapp',
                                prefixIcon: const SvgIcon(
                                  assetName:
                                      'assets/icons/whatsapp-business.svg',
                                  color: Color(0xFFE30613),
                                  size: 10,
                                ),
                              ),
                            ),
                          if (isContactDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: whatsappController,
                                labelText: 'Enter Whatsapp',
                                prefixIcon: const SvgIcon(
                                  assetName: 'assets/icons/whatsapp.svg',
                                  color: Color(0xFFE30613),
                                  size: 13,
                                ),
                              ),
                            ),
                          if (isContactDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: CustomTextFormField(
                                textController: addressController,
                                labelText: 'Enter Address',
                                maxLines: 3,
                                prefixIcon: const Icon(Icons.location_on,
                                    color: Color(0xFFE30613)),
                              ),
                            ),
                          if (isContactDetailsVisible)
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
                                  'Enter Products',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value: ref
                                      .watch(isProductsDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isProductsDetailsVisibleProvider
                                              .notifier)
                                          .state = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (user.products != null && isProductsDetailsVisible)
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
                                      1.0, // Space between columns
                                  mainAxisSpacing: 2.0, // Space between rows
                                  childAspectRatio:
                                      .92, // Aspect ratio for the cards
                                ),
                                itemCount: user.products!.length,
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                      product: user.products![index],
                                      onRemove: () => _removeProduct(index));
                                },
                              ),
                            ),
                          if (isProductsDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, bottom: 60),
                              child: GestureDetector(
                                onTap: () {
                                  _openModalSheet(
                                    sheet: 'product',
                                  );
                                },
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
                                          'Enter Products',
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
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Enter Brochure',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                CustomSwitch(
                                  value: ref
                                      .watch(isBrochureDetailsVisibleProvider),
                                  onChanged: (bool value) {
                                    setState(() {
                                      ref
                                          .read(isBrochureDetailsVisibleProvider
                                              .notifier)
                                          .state = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (user.brochure!.isNotEmpty &&
                              isBrochureDetailsVisible)
                            ListView.builder(
                              shrinkWrap:
                                  true, // Let ListView take up only as much space as it needs
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable ListView's internal scrolling
                              itemCount: user.brochure!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0), // Space between items
                                  child: BrochureCard(
                                    brochure: user.brochure![index],
                                    onRemove: () => _removeBrochure(index),
                                  ),
                                );
                              },
                            ),
                          if (isBrochureDetailsVisible)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, bottom: 60),
                              child: GestureDetector(
                                onTap: () => _openModalSheet(sheet: 'brochure'),
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
                                          'Enter Brochure',
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
