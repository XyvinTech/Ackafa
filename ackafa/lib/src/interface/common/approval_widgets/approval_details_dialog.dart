import 'package:flutter/material.dart';

void showCustomPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildDetailRow('Member name', 'Prabodhan Fitzgerald'),
              SizedBox(height: 10),
              _buildDetailRow(
                'Status',
                'Pending payment',
                customWidget: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Pending payment',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildDetailRow('Approved by', 'Somekshwar'),
              SizedBox(height: 10),
              _buildDetailRow(
                'Approval date',
                'Friday. 12:10 pm\n17th July 2024',
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildDetailRow(String title, String value, {Widget? customWidget}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(),
        ),
        Spacer(),
        customWidget ??
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
      ],
    ),
  );
}