
import 'package:ackaf/src/interface/common/components/custom_snackbar.dart';
import 'package:contact_add/contact.dart';
import 'package:contact_add/contact_add.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

Future<void> saveContact(
    {required String number,
    required String firstName,    required String lastName,required String email,
    required BuildContext context}) async {
  // Request permission to access contacts

    final Contact contact = Contact(
        firstname: firstName,
        lastname: lastName,

        phone: number,
        email: email);

    final bool success = await ContactAdd.addContact(contact);

    if (success) {
      CustomSnackbar.showSnackbar(context, 'Contact saved successfully!');
    } else {
      CustomSnackbar.showSnackbar(context, 'Contact saving failed!');
    }
 
}
