import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/providers/user_provider.dart';
import 'package:ackaf/src/interface/screens/main_pages/loginPages/paymentpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInactivePage extends ConsumerWidget {
  const UserInactivePage({super.key});

  static const Color _subtitleColor = Color(0xFF757575);
  static const Color _cardFill = Color(0xFFF5F5F5);
  static const Color _successGreen = Color(0xFF22C55E);
  static const Color _activeOrange = Color(0xFFF59E0B);
  static const Color _pendingGray = Color(0xFFD1D5DB);
  static const double _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;
    final isRejected = user?.status == 'rejected';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.red,
          onRefresh: () async {
            final refreshedUser =
                await ref.read(userProvider.notifier).refreshUser();
            if (refreshedUser?.status == 'awaiting_payment') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentConfirmationPage(),
                ),
              );
            }
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              _horizontalPadding,
              32,
              _horizontalPadding,
              24,
            ),
            children: [
              if (isRejected) ...[
                const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 72,
                ),
                const SizedBox(height: 20),
                Text(
                  'Your membership request has been rejected',
                  style: const TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: Colors.red,
                  ),
                ),
              ] else ...[
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _successGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _successGreen.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Request Send',
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Track your request below — no need to keep checking, we'll notify you at each step.",
                  style: TextStyle(
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
                    children: const [
                      _StatusStep(
                        state: _StepState.completed,
                        stepNumber: 1,
                        title: 'Request submitted',
                        subtitle: 'Today, 02:23 pm',
                        showConnector: true,
                      ),
                      _StatusStep(
                        state: _StepState.active,
                        stepNumber: 2,
                        title: 'Under review',
                        subtitle:
                            'An admin is verifying your details. Usually takes under 48 hours.',
                        showConnector: true,
                      ),
                      _StatusStep(
                        state: _StepState.pending,
                        stepNumber: 3,
                        title: 'Activate Membership',
                        subtitle: 'Final step once you approved.',
                        showConnector: true,
                      ),
                      _StatusStep(
                        state: _StepState.pending,
                        stepNumber: 4,
                        title: 'Welcome aboard',
                        subtitle: 'Full app access granted',
                        showConnector: false,
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              Center(
                child: TextButton(
                  onPressed: () async {
                    LoggedIn = false;
                    final SharedPreferences preferences =
                        await SharedPreferences.getInstance();

                    preferences.setString('token', '');
                    preferences.setString('id', '');

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login_screen',
                      (Route<dynamic> route) => false,
                    );

                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1A1A1A),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _StepState { completed, active, pending }

class _StatusStep extends StatelessWidget {
  const _StatusStep({
    required this.state,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.showConnector,
  });

  final _StepState state;
  final int stepNumber;
  final String title;
  final String subtitle;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _StepIndicator(state: state, stepNumber: stepNumber),
              if (showConnector)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: CustomPaint(
                      size: const Size(2, double.infinity),
                      painter: _DashedLinePainter(
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
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: UserInactivePage._subtitleColor,
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

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.state,
    required this.stepNumber,
  });

  final _StepState state;
  final int stepNumber;

  @override
  Widget build(BuildContext context) {
    if (state == _StepState.completed) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: UserInactivePage._successGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 16,
        ),
      );
    }

    final color = state == _StepState.active
        ? UserInactivePage._activeOrange
        : UserInactivePage._pendingGray;

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
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: state == _StepState.active ? Colors.white : Colors.white,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

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
