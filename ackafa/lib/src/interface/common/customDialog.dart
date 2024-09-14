import 'package:ackaf/src/data/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPolicyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Circular border
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Policy Agreement',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Before proceeding to upload images, you must agree to our Terms and Conditions (EULA) and adhere to our content guidelines. Please read the following carefully:',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 15),
              Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'By uploading images, you agree to the following:',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10),
              _buildListItem(
                  'No Objectionable Content: You may not upload any content that is obscene, offensive, abusive, defamatory, or illegal in nature. This includes but is not limited to:'),
              _buildSubItem(
                  '- Images depicting violence, nudity, hate speech, or discriminatory content.'),
              _buildSubItem(
                  '- Material that promotes harassment, bullying, or harm to any individual or group.'),
              SizedBox(height: 10),
              _buildListItem(
                  'No Tolerance for Abusive Behavior: Users engaging in abusive behavior, including but not limited to harassment, threats, or harmful comments towards other users, will be banned without warning.'),
              SizedBox(height: 10),
              _buildListItem(
                  'Content Ownership: You certify that you own the rights to all images you upload or have obtained permission to use them.'),
              SizedBox(height: 10),
              _buildListItem(
                  'Consequences of Violations: Any violation of these terms may result in the immediate suspension or termination of your account without prior notice.'),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setBool('isAgreed', true);
                        isAgreed = true;
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Agree',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Text(
      '• $text',
      style: TextStyle(fontSize: 16.0, height: 1.5),
    );
  }

  Widget _buildSubItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.0, height: 1.4),
      ),
    );
  }
}

void showUploadPolicyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UploadPolicyDialog();
    },
  );
}
