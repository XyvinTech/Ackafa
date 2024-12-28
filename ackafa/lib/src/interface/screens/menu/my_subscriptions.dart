import 'package:ackaf/src/data/services/api_routes/user_api.dart';
import 'package:ackaf/src/interface/common/custom_button.dart';
import 'package:ackaf/src/interface/common/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MySubscriptionPage extends StatelessWidget {
  const MySubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'My Subscription',
          style: TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: .5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Membership Subscription Card
              Consumer(
                builder: (context, ref, child) {
           
              return    _SubscriptionCard(
                    title: "App subscription",
                    plan: "Active",
                    planColor: Colors.green,
                    lastRenewedDate: "12th July 2025",
                    amount: "₹2000",
                    dueOrExpiryDate: "12th July 2026",
                    dueOrExpiryLabel: "Due date",
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final String title;
  final String plan;
  final Color planColor;
  final String lastRenewedDate;
  final String amount;
  final String dueOrExpiryDate;
  final String dueOrExpiryLabel;

  const _SubscriptionCard({
    required this.title,
    required this.plan,
    required this.planColor,
    required this.lastRenewedDate,
    required this.amount,
    required this.dueOrExpiryDate,
    required this.dueOrExpiryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color.fromARGB(255, 227, 220, 220))),
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF686465),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "Plan",
                  style: TextStyle(
                      color: Color(0xFF686465),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: planColor.withOpacity(0.2),
                    border: Border.all(color: planColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    plan,
                    style: TextStyle(
                      color: planColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: const Color.fromARGB(255, 235, 231, 231),
            ),

            // Details
            _DetailRow(label: "Last Renewed date", value: lastRenewedDate),
            Divider(
              color: const Color.fromARGB(255, 235, 231, 231),
            ),
            _DetailRow(label: "Amount to be paid", value: amount),
            Divider(
              color: const Color.fromARGB(255, 235, 231, 231),
            ),
            _DetailRow(label: dueOrExpiryLabel, value: dueOrExpiryDate),
            Divider(
              color: const Color.fromARGB(255, 235, 231, 231),
            ),
            const SizedBox(height: 16),
            // Button
            SizedBox(
                width: double.infinity,
                child: customButton(
                  fontSize: 13,
                  label: 'EXTEND SUBSCRIPTION',
                  onPressed: () async {
                    ApiRoutes userApi = ApiRoutes();
                    String? paymentUrl = await userApi.makePayment();
                    if (paymentUrl != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PaymentWebView(
                                paymentUrl: paymentUrl,
                              )));
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF686465)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
