import 'dart:developer';

import 'package:ackaf/src/data/models/college_model.dart';
import 'package:ackaf/src/data/models/user_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';

class ModalSheetTextFormField extends StatelessWidget {
  final TextEditingController textController;
  final String? label;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool isAward;

  const ModalSheetTextFormField({
    required this.textController,
    required this.label,
    this.maxLines = 1,
    this.validator,
    super.key,
    this.isAward = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: isAward ? 15 : null,
      controller: textController,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey, // Set the border color to light grey
            width: 1.0, // You can adjust the width as needed
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 185, 181, 181),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 185, 181, 181),
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final bool readOnly;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? textController;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onChanged;
  final bool? enabled;
  final bool? isAward;
  final Color? fillColor;
  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.readOnly = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.onTap,
    this.suffixIcon,
    required this.textController,
    this.validator,
    this.onChanged,
    this.enabled,
    this.isAward,
    this.fillColor = const Color(0xFFF2F2F2),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return TextFormField(
          enabled: enabled,
          onChanged: (value) {
            switch (labelText) {
              case 'Enter Your Full name':
                ref.read(userProvider.notifier).updateName(
                      name: textController!.text,
                    );
                break;
              case 'Enter Your Email ID':
                ref.read(userProvider.notifier).updateName(
                      name: textController!.text,
                    );
                break;
              case 'Enter Your Emirates ID':
                ref.read(userProvider.notifier).updateEmiratesID(
                      emiratesID: textController!.text,
                    );
                break;
              case 'Enter Your Phone':
                ref
                    .read(userProvider.notifier)
                    .updatePhone(textController!.text);
                break;
              case 'Select Your College':
                ref
                    .read(userProvider.notifier)
                    .updateCollege(textController!.text);
                break;
              case 'Enter Personal Address':
                ref
                    .read(userProvider.notifier)
                    .updateAddress(textController!.text);
                break;

              case 'Enter Designation':
                ref
                    .read(userProvider.notifier)
                    .updateCompany(Company(designation: textController!.text));
              case 'Bio':
                log('Bio ${textController!.text}');
                ref.read(userProvider.notifier).updateBio(textController!.text);
              case 'Enter Company Name':
                ref
                    .read(userProvider.notifier)
                    .updateCompany(Company(name: textController!.text));
              case 'Enter Company Phone':
                ref
                    .read(userProvider.notifier)
                    .updateCompany(Company(phone: textController!.text));
              case 'Enter Company Address':
                ref
                    .read(userProvider.notifier)
                    .updateCompany(Company(address: textController!.text));

              case 'Enter Instagram':
                ref.read(userProvider.notifier).updateSocialMedia(
                    [...?ref.read(userProvider).value?.social],
                    'instagram',
                    textController!.text);

              case 'Enter Linkedin':
                ref.read(userProvider.notifier).updateSocialMedia(
                    [...?ref.read(userProvider).value?.social],
                    'linkedin',
                    textController!.text);
              case 'Enter Twitter':
                ref.read(userProvider.notifier).updateSocialMedia(
                    [...?ref.read(userProvider).value?.social],
                    'twitter',
                    textController!.text);
              case 'Enter Facebook':
                ref.read(userProvider.notifier).updateSocialMedia(
                    [...?ref.read(userProvider).value?.social],
                    'facebook',
                    textController!.text);

              default:
            }
          },
          readOnly: readOnly,
          controller: textController,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.grey),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: fillColor,
            filled: true,
            prefixIcon: prefixIcon != null && maxLines > 1
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: 50, left: 10, right: 10, top: 5),
                    child: Align(
                      alignment: Alignment.topCenter,
                      widthFactor: 1.0,
                      heightFactor: maxLines > 1 ? null : 1.0,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          width: 42,
                          height: 42,
                          child: prefixIcon),
                    ),
                  )
                : prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Align(
                          alignment: Alignment.topCenter,
                          widthFactor: 1.0,
                          heightFactor: maxLines > 1 ? null : 1.0,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              width: 42,
                              height: 42,
                              child: prefixIcon),
                        ),
                      )
                    : null,
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          width: 42,
                          height: 42,
                          child: suffixIcon),
                    ),
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                  color: Color.fromARGB(
                      255, 212, 209, 209)), // Unfocused border color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                  color: Color.fromARGB(
                      255, 223, 220, 220)), // Focused border color
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                  color: Color.fromARGB(
                      255, 212, 209, 209)), // Same as enabled border
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                  color: Color.fromARGB(
                      255, 223, 220, 220)), // Same as focused border
            ),
          ),
        );
      },
    );
  }
}

class CustomTextFormField2 extends StatelessWidget {
  final String labelText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? textController;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField2({
    Key? key,
    this.labelText = '',
    this.readOnly = false,
    this.enabled = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.onTap,
    this.suffixIcon,
    this.textController,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: textController,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFF2C2829)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        fillColor: const Color(0xFFF2F2F2),
        filled: true,
        prefixIcon: prefixIcon != null && maxLines > 1
            ? Padding(
                padding: const EdgeInsets.only(
                    bottom: 50, left: 10, right: 10, top: 5),
                child: Align(
                  alignment: Alignment.topCenter,
                  widthFactor: 1.0,
                  heightFactor: maxLines > 1 ? null : 1.0,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      width: 42,
                      height: 42,
                      child: prefixIcon),
                ),
              )
            : prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Align(
                      alignment: Alignment.topCenter,
                      widthFactor: 1.0,
                      heightFactor: maxLines > 1 ? null : 1.0,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          width: 42,
                          height: 42,
                          child: prefixIcon),
                    ),
                  )
                : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      width: 42,
                      height: 42,
                      child: suffixIcon),
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color:
                  Color.fromARGB(255, 212, 209, 209)), // Unfocused border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color:
                  Color.fromARGB(255, 223, 220, 220)), // Focused border color
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color:
                  Color.fromARGB(255, 212, 209, 209)), // Same as enabled border
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color:
                  Color.fromARGB(255, 223, 220, 220)), // Same as focused border
        ),
      ),
    );
  }
}
