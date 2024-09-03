import 'dart:developer';

import 'package:ackaf/src/data/models/college_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';

class ModalSheetTextFormField extends StatelessWidget {
  final TextEditingController textController;
  final String? label;
  final int maxLines;
  final String? Function(String?)? validator;

  const ModalSheetTextFormField({
    required this.textController,
    required this.label,
    this.maxLines = 1,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final user = ref.watch(userProvider);
        return TextFormField(
          onChanged: (value) {
            switch (labelText) {
              case 'Enter your Full name':
                List<String> nameParts = textController!.text.split(' ');

                String firstName = nameParts[0];
                String middleName = nameParts.length > 2 ? nameParts[1] : ' ';
                String lastName = nameParts.length > 1 ? nameParts.last : ' ';
                ref.read(userProvider.notifier).updateName(
                    firstName: firstName,
                    middleName: middleName,
                    lastName: lastName);
                break;
              case 'Designation':
                ref
                    .read(userProvider.notifier)
                    .updateDesignation(textController!.text);
              case 'Bio':
                ref.read(userProvider.notifier).updateBio(textController!.text);
              case 'Enter Company Name':
                ref
                    .read(userProvider.notifier)
                    .updateCompanyName(textController!.text);
              case 'Enter Company Address':
                ref
                    .read(userProvider.notifier)
                    .updateCompanyAddress(textController!.text);
              case 'Enter phone number':
                ref.read(userProvider.notifier).updatePhoneNumbers(
                    personal: int.parse(textController!.text));
              case 'Enter landline number':
                ref.read(userProvider.notifier).updatePhoneNumbers(
                    landline: int.parse(textController!.text));
              case 'Enter Ig':
                ref.read(userProvider.notifier).updateSocialMedia(
                    [...?ref.read(userProvider).value?.socialMedia],
                    'instagram',
                    textController!.text);

              case 'Enter Linkedin':
                ref.read(userProvider.notifier).updateSocialMedia(
                    [...?ref.read(userProvider).value?.socialMedia],
                    'linkedin',
                    textController!.text);
              case 'Enter Twitter':
                ref.read(userProvider.notifier).updateSocialMedia(
                    [...?ref.read(userProvider).value?.socialMedia],
                    'twitter',
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
class CustomDropdownButton<T> extends StatelessWidget {
  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<T>? validator;

  const CustomDropdownButton({
    Key? key,
    required this.labelText,
    required this.items,
    this.value,
    this.onChanged,
    this.onTap,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      value: value,
      hint: Text(labelText),
      items: items,
      validator: validator,
      onChanged: onChanged,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        elevation: 8,
      ),
      menuItemStyleData: MenuItemStyleData(
        customHeights: List<double>.filled(
            items.length, 48.0),
        selectedMenuItemBuilder: (context, child) => Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.red.withOpacity(0.1),
          ),
          child: child,
        ),
      ),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        fillColor: const Color(0xFFF2F2F2),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 212, 209, 209)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 223, 220, 220)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 212, 209, 209)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 223, 220, 220)),
        ),
      ),
    );
  }
}