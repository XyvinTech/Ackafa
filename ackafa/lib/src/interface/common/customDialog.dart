import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPolicyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 12,
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Increased width
        height: MediaQuery.of(context).size.height * 0.5, // Decreased height
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24.0),
                    _buildDescription(context),
                    const SizedBox(height: 30.0),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 24.0),
                    _buildTermsSection(context),
                    const SizedBox(height: 30.0),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(
                        height: 80.0), // Padding for the actions below
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  _buildArrowIndicator(),
                  _buildActions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'EULA & Upload Policy Agreement',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0,
                  color: Colors.blueGrey[900],
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      'Before uploading images, please review and agree to our Terms and Conditions (EULA & Upload Policy Agreement) and content guidelines.',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 16.0,
            height: 1.6,
            color: Colors.blueGrey[700],
          ),
    );
  }

  Widget _buildTermsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Terms and Conditions'),
        _buildListItem(
            'No Objectionable Content: Uploading content that is obscene, offensive, or illegal is prohibited.'),
        _buildSubItem(
            '- Violence, nudity, hate speech, or discriminatory content.'),
        _buildSubItem(
            '- Harassment, bullying, or harmful content towards individuals or groups.'),
        const SizedBox(height: 10),
        _buildListItem(
            'No Tolerance for Abusive Behavior: Users engaging in abusive behavior will be banned.'),
        const SizedBox(height: 10),
        _buildListItem(
            'Content Ownership: You certify ownership of all images you upload.'),
        const SizedBox(height: 10),
        _buildListItem(
            'Consequences: Violations may result in immediate suspension or termination.'),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: Colors.blueGrey[800],
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle,
              size: 18.0, color: Colors.greenAccent.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                height: 1.5,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.0,
          height: 1.5,
          color: Colors.blueGrey[600],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setBool('isAgreed', true);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE30613), // Changed to red color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 14.0),
                shadowColor: Colors.red.withOpacity(0.3),
                elevation: 6,
              ),
              child: Text(
                'Agree',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArrowIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Icon(
        Icons.keyboard_arrow_down,
        size: 32,
        color: Colors.grey.shade600,
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
