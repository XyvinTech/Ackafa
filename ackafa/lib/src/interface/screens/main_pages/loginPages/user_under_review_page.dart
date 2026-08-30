import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/paymentpage.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/user_inactive_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserUnderReviewPage extends ConsumerWidget {
  const UserUnderReviewPage({super.key});

  static const Color _labelColor = Color(0xFF9A7B5A);
  static const Color _subtitleColor = Color(0xFF757575);
  static const Color _cardFill = Color(0xFFF5F5F5);
  static const Color _successGreen = Color(0xFF22C55E);
  static const Color _activeOrange = Color(0xFFF59E0B);
  static const Color _pendingGray = Color(0xFFD1D5DB);
  static const Color _pendingText = Color(0xFF9CA3AF);
  static const double _horizontalPadding = 24.0;

  String _resolveUserStatus(String? status) {
    final s = status?.toLowerCase() ?? 'inactive';
    if (!isPaymentEnabled &&
        (s == 'awaiting_payment' || s == 'subscription_expired')) {
      return 'active';
    }
    return s;
  }

  String _submittedText() {
    return 'Submitted recently · usually takes under 48 hours.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;

    if (user?.status == 'rejected') {
      return const UserInactivePage();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.red,
          onRefresh: () async {
            final refreshedUser =
                await ref.read(userProvider.notifier).refreshUser();
            final refreshedStatus =
                _resolveUserStatus(refreshedUser?.status);
            if (!context.mounted) return;
            if (refreshedStatus == 'awaiting_payment') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentConfirmationPage(),
                ),
              );
            } else if (refreshedStatus == 'active') {
              Navigator.pushReplacementNamed(context, '/mainpage');
            }
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              _horizontalPadding,
              24,
              _horizontalPadding,
              32,
            ),
            children: [
              Center(
                child: Image.asset(
                  'assets/splashAkcaf.png',
                  width: 120,
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                'APPLICATION STATUS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: _labelColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Under review',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _submittedText(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                  color: _subtitleColor,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'What happens next',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                decoration: BoxDecoration(
                  color: _cardFill,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _ReviewStatusStep(
                      state: _ReviewStepState.completed,
                      stepNumber: 1,
                      title: 'Request submitted',
                      subtitle: DateFormat('d MMM, hh:mm a').format(
                        DateTime.now(),
                      ),
                      showConnector: true,
                    ),
                    const _ReviewStatusStep(
                      state: _ReviewStepState.active,
                      stepNumber: 2,
                      title: 'Under review',
                      subtitle: 'An admin is verifying your details.',
                      showConnector: true,
                    ),
                    const _ReviewStatusStep(
                      state: _ReviewStepState.pending,
                      stepNumber: 3,
                      title: 'Activate Membership',
                      subtitle: 'Final step once you approved.',
                      showConnector: true,
                    ),
                    const _ReviewStatusStep(
                      state: _ReviewStepState.pending,
                      stepNumber: 4,
                      title: 'Welcome aboard',
                      subtitle: 'Full app access granted',
                      showConnector: false,
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
}

enum _ReviewStepState { completed, active, pending }

class _ReviewStatusStep extends StatelessWidget {
  const _ReviewStatusStep({
    required this.state,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.showConnector,
  });

  final _ReviewStepState state;
  final int stepNumber;
  final String title;
  final String subtitle;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final isPending = state == _ReviewStepState.pending;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _ReviewStepIndicator(
                state: state,
                stepNumber: stepNumber,
              ),
              if (showConnector)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: CustomPaint(
                      size: const Size(2, double.infinity),
                      painter: _ReviewDashedLinePainter(
                        color: const Color(0xFFBDBDBD),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showConnector ? 18 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: isPending
                          ? UserUnderReviewPage._pendingText
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: isPending
                          ? UserUnderReviewPage._pendingText
                          : UserUnderReviewPage._subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewStepIndicator extends StatelessWidget {
  const _ReviewStepIndicator({
    required this.state,
    required this.stepNumber,
  });

  final _ReviewStepState state;
  final int stepNumber;

  @override
  Widget build(BuildContext context) {
    if (state == _ReviewStepState.completed) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: UserUnderReviewPage._successGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 16,
        ),
      );
    }

    final color = state == _ReviewStepState.active
        ? UserUnderReviewPage._activeOrange
        : UserUnderReviewPage._pendingGray;

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$stepNumber',
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ReviewDashedLinePainter extends CustomPainter {
  const _ReviewDashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
