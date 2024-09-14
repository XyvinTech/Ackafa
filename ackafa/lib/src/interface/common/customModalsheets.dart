import 'dart:io';

import 'package:ackaf/src/data/models/chat_model.dart';
import 'package:ackaf/src/data/models/feed_model.dart';
import 'package:ackaf/src/data/services/api_routes/chat_api.dart';
import 'package:ackaf/src/data/services/api_routes/image_upload.dart';
import 'package:ackaf/src/interface/common/custom_dropdowns/custom_dropdowns.dart';
import 'package:ackaf/src/interface/screens/people/chat/chatscreen.dart';
import 'package:ackaf/src/interface/validatelinks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/customTextfields.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

void feedModalSheet({
  required BuildContext context,
  required VoidCallback onButtonPressed,
  required String buttonText,
  required Feed feed,
  required Participant sender,
  required Participant receiver,
  // Made imageUrl optional
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Conditionally render the image
              if (feed.media != null && feed.media != '')
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20.0)),
                  child: Image.network(
                    feed.media!,
                    width: double.infinity,
                    height: 200, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                ),
              // Add spacing only if image is displayed
              if (feed.media != null && feed.media != '')
                const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Consumer(
                  builder: (context, ref, child) {
                    return customButton(
                      label: buttonText,
                      onPressed: () async {
                        await sendChatMessage(
                            userId: feed.author!,
                            content: feed.content!,
                            feedId: feed.id);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => IndividualPage(
                                  receiver: receiver,
                                  sender: sender,
                                )));
                      },
                      fontSize: 16,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          // Close button positioned at the top-right of the sheet
          Positioned(
            right: 5,
            top: -50,
            child: Container(
              padding: const EdgeInsets.all(0),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showWebsiteSheet({
  required VoidCallback addWebsite,
  required String title,
  required String fieldName,
  required BuildContext context,
  required TextEditingController textController1,
  required TextEditingController textController2,
}) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return Form(
        key: _formKey,
        child: Stack(
          clipBehavior:
              Clip.none, // Allow content to overflow outside the stack
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ModalSheetTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is a required field';
                      }
                      return null;
                    },
                    label: 'Add name',
                    textController: textController1,
                  ),
                  const SizedBox(height: 10),
                  ModalSheetTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a website';
                      }

                      return null;
                    },
                    label: fieldName,
                    textController: textController2,
                  ),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      return customButton(
                        label: 'SAVE',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addWebsite();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Saved')),
                            );
                            Navigator.pop(context);
                          }
                        },
                        fontSize: 16,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Positioned(
              right: 5,
              top: -50,
              child: Container(
                padding: const EdgeInsets.all(0),
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showVideoLinkSheet({
  required VoidCallback addVideo,
  required String title,
  required String fieldName,
  required BuildContext context,
  required TextEditingController textController1,
  required TextEditingController textController2,
}) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return Form(
        key: _formKey,
        child: Stack(
          clipBehavior:
              Clip.none, // Allow content to overflow outside the stack
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ModalSheetTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is a required field';
                      }
                      return null;
                    },
                    label: 'Add name',
                    textController: textController1,
                  ),
                  const SizedBox(height: 10),
                  fieldName == 'Add Youtube Link'
                      ? ModalSheetTextFormField(
                          validator: (value) => validateYouTubeUrl(value),
                          label: fieldName,
                          textController: textController2,
                        )
                      : ModalSheetTextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This is a required field';
                            }
                            return null;
                          },
                          label: fieldName,
                          textController: textController2,
                        ),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      return customButton(
                        label: 'SAVE',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addVideo();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Saved')),
                            );
                            Navigator.pop(context);
                          }
                        },
                        fontSize: 16,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Positioned(
              right: 5,
              top: -50,
              child: Container(
                padding: const EdgeInsets.all(0),
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class ShowEnterAwardtSheet extends StatefulWidget {
  final TextEditingController textController1;
  final TextEditingController textController2;
  final VoidCallback addAwardCard;
  final String imageType;
  File? awardImage;
  final Future<File?> Function({required String imageType}) pickImage;

  ShowEnterAwardtSheet({
    required this.textController1,
    required this.textController2,
    required this.addAwardCard,
    required this.pickImage,
    required this.imageType,
    this.awardImage,
    super.key,
  });

  @override
  State<ShowEnterAwardtSheet> createState() => _ShowEnterAwardtSheetState();
}

class _ShowEnterAwardtSheetState extends State<ShowEnterAwardtSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Awards',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FormField<File>(
              initialValue: widget.awardImage,
              validator: (value) {
                if (value == null) {
                  return 'Please upload an image';
                }
                return null;
              },
              builder: (FormFieldState<File> state) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile =
                            await widget.pickImage(imageType: widget.imageType);
                        setState(() {
                          widget.awardImage = pickedFile;
                          state.didChange(pickedFile);
                        });
                      },
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: state.hasError
                              ? Border.all(color: Colors.red)
                              : null,
                        ),
                        child: widget.awardImage == null
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        size: 27, color: Color(0xFFE30613)),
                                    SizedBox(height: 10),
                                    Text(
                                      'Upload Image',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 102, 101, 101)),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Image.file(
                                widget.awardImage!,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              )),
                      ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(
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
            ModalSheetTextFormField(
              label: 'Add name',
              textController: widget.textController1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            ModalSheetTextFormField(
              label: 'Add Authority name',
              textController: widget.textController2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the authority name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            customButton(
              label: 'SAVE',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.addAwardCard();
                  Navigator.pop(context);
                }
              },
              fontSize: 16,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ShowAddCertificateSheet extends StatefulWidget {
  final TextEditingController textController;
  final String imageType;
  File? certificateImage;

  final Future<File?> Function({required String imageType}) pickImage;
  final VoidCallback addCertificateCard;

  ShowAddCertificateSheet({
    super.key,
    required this.textController,
    required this.imageType,
    this.certificateImage,
    required this.pickImage,
    required this.addCertificateCard,
  });

  @override
  State<ShowAddCertificateSheet> createState() =>
      _ShowAddCertificateSheetState();
}

class _ShowAddCertificateSheetState extends State<ShowAddCertificateSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Certificates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FormField<File>(
              initialValue: widget.certificateImage,
              validator: (value) {
                if (value == null) {
                  return 'Please upload an image';
                }
                return null;
              },
              builder: (FormFieldState<File> state) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile =
                            await widget.pickImage(imageType: widget.imageType);
                        setState(() {
                          widget.certificateImage = pickedFile;
                          state
                              .didChange(pickedFile); // Update form field state
                        });
                      },
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: state.hasError
                              ? Border.all(color: Colors.red)
                              : null,
                        ),
                        child: widget.certificateImage == null
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        size: 27, color: Color(0xFFE30613)),
                                    SizedBox(height: 10),
                                    Text(
                                      'Upload Image',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 102, 101, 101)),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Image.file(
                                  widget.certificateImage!,
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                      ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(
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
            ModalSheetTextFormField(
              label: 'Add Name',
              textController: widget.textController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            customButton(
              label: 'SAVE',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.addCertificateCard();
                  Navigator.pop(context);
                }
              },
              fontSize: 16,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ShowAddBrochureSheet extends StatefulWidget {
  final TextEditingController textController;
  final Future<File?> Function({required String imageType}) pickPdf;
  final VoidCallback addBrochureCard;
  final String brochureName;
  String imageType;

  ShowAddBrochureSheet({
    super.key,
    required this.textController,
    required this.pickPdf,
    required this.addBrochureCard,
    required this.brochureName,
    required this.imageType,
  });

  @override
  State<ShowAddBrochureSheet> createState() => _ShowAddBrochureSheetState();
}

class _ShowAddBrochureSheetState extends State<ShowAddBrochureSheet> {
  final _formKey = GlobalKey<FormState>();
  File? brochurePdf;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Brochure',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FormField<File>(
              initialValue: brochurePdf,
              validator: (value) {
                if (value == null) {
                  return 'Please upload a PDF';
                }
                return null;
              },
              builder: (FormFieldState<File> state) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile =
                            await widget.pickPdf(imageType: widget.imageType);
                        setState(() {
                          brochurePdf = pickedFile;
                          state.didChange(pickedFile);
                        });
                      },
                      child: brochurePdf == null
                          ? Container(
                              height: 110,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border: state.hasError
                                    ? Border.all(color: Colors.red)
                                    : null,
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        size: 27, color: Color(0xFFE30613)),
                                    SizedBox(height: 10),
                                    Text(
                                      'Upload PDF',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 102, 101, 101)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const Center(
                              child: Text(
                                'PDF ADDED',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(
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
            ModalSheetTextFormField(
              label: 'Add Name',
              textController: widget.textController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name for the brochure';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            customButton(
              label: 'SAVE',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.addBrochureCard();
                  Navigator.pop(context);
                }
              },
              fontSize: 16,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ShowEnterProductsSheet extends StatefulWidget {
  String productPriceType;
  final TextEditingController productNameText;
  final TextEditingController descriptionText;
  final TextEditingController moqText;
  final TextEditingController actualPriceText;
  final TextEditingController offerPriceText;

  final VoidCallback addProductCard;
  final String imageType;
  File? productImage;
  final Future<File?> Function({required String imageType}) pickImage;

  ShowEnterProductsSheet({
    super.key,
    required this.productPriceType,
    required this.productNameText,
    required this.descriptionText,
    required this.moqText,
    required this.actualPriceText,
    required this.offerPriceText,
    required this.addProductCard,
    required this.imageType,
    this.productImage,
    required this.pickImage,
  });

  @override
  State<ShowEnterProductsSheet> createState() => _ShowEnterProductsSheetState();
}

class _ShowEnterProductsSheetState extends State<ShowEnterProductsSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FormField<File>(
                initialValue: widget.productImage,
                validator: (value) {
                  if (value == null) {
                    return 'Please upload an image';
                  }
                  return null;
                },
                builder: (FormFieldState<File> state) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: LoadingAnimation(),
                              );
                            },
                          );

                          final pickedFile = await widget.pickImage(
                              imageType: widget.imageType);
                          setState(() {
                            widget.productImage = pickedFile;
                            state.didChange(pickedFile); // Update form state
                          });

                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: state.hasError
                                ? Border.all(color: Colors.red)
                                : null,
                          ),
                          child: widget.productImage == null
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          size: 27, color: Color(0xFFE30613)),
                                      SizedBox(height: 10),
                                      Text(
                                        'Upload Image',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 102, 101, 101)),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Image.file(
                                    widget.productImage!,
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                        ),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            state.errorText!,
                            style: const TextStyle(
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
              ModalSheetTextFormField(
                textController: widget.productNameText,
                label: 'Add name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ModalSheetTextFormField(
                textController: widget.descriptionText,
                label: 'Add description',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ModalSheetTextFormField(
                textController: widget.moqText,
                label: 'Add MOQ',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the MOQ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: ModalSheetTextFormField(
                      textController: widget.actualPriceText,
                      label: 'Actual price',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the actual price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: ModalSheetTextFormField(
                      textController: widget.offerPriceText,
                      label: 'Offer price',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the offer price';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 185, 181, 181),
                      width: 1.0,
                    ),
                  ),
                ),
                onPressed: () {
                  _showProductPriceTypeDialog(context).then((value) {
                    if (value != null) {
                      widget.productPriceType = value;
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.productPriceType,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 94, 93, 93)),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              customButton(
                label: 'Save',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.addProductCard();
                    Navigator.pop(context);
                  }
                },
                fontSize: 16,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> _showProductPriceTypeDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text('Select an Option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Price per unit'),
              onTap: () {
                Navigator.of(context).pop('Price per unit');
              },
            ),
            ListTile(
              title: const Text('Option 2'),
              onTap: () {
                Navigator.of(context).pop('Option 2');
              },
            ),
          ],
        ),
      );
    },
  );
}

class ShowAddPostSheet extends StatefulWidget {
  final Future<File?> Function({required String imageType}) pickImage;
  final TextEditingController textController;
  final String imageType;
  File? postImage;

  ShowAddPostSheet({
    super.key,
    required this.textController,
    required this.imageType,
    required this.postImage,
    required this.pickImage,
  });

  @override
  State<ShowAddPostSheet> createState() => _ShowAddPostSheetState();
}

class _ShowAddPostSheetState extends State<ShowAddPostSheet> {
  String? selectedType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? mediaUrl;
  @override
  Widget build(BuildContext context) {
    ApiRoutes api = ApiRoutes();

    return PopScope(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          // Added this widget
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PUBLISH',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                CustomDropdownButton2(
                  onValueChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FormField<File>(
                  initialValue: widget.postImage,
                  builder: (FormFieldState<File> state) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final pickedFile = await widget.pickImage(
                                imageType: widget.imageType);
                            setState(() {
                              widget.postImage = pickedFile;
                              state.didChange(pickedFile);
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: state.hasError
                                  ? Border.all(color: Colors.red)
                                  : null,
                            ),
                            child: widget.postImage == null
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add,
                                            size: 27, color: Color(0xFFE30613)),
                                        SizedBox(height: 10),
                                        Text(
                                          'Upload Image',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 102, 101, 101)),
                                        ),
                                      ],
                                    ),
                                  )
                                : Image.file(
                                    widget.postImage!,
                                    fit: BoxFit.fill,
                                    width: 120,
                                    height: 120,
                                  ),
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(
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
                TextFormField(
                  controller: widget.textController,
                  maxLines: ((MediaQuery.sizeOf(context).height) / 150).toInt(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Add content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(selectedType);
                      if (widget.postImage != null) {
                        mediaUrl = await imageUpload(
                            basename(widget.postImage!.path),
                            widget.postImage!.path);
                      }
                      api.uploaPost(
                        type: selectedType ?? '',
                        media: mediaUrl,
                        content: widget.textController.text,
                      );

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Your Post Will Be Reviewed By Admin')),
                      );
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFFE30613)),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFFE30613)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Color(0xFFE30613)),
                      ),
                    ),
                  ),
                  child: const Text(
                    'ADD POST',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
