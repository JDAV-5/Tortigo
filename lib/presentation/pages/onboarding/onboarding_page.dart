import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
void initState() {
  super.initState();
  _goToLogin();
}

  Future<void> _goToLogin() async {
  await Future.delayed(
    const Duration(seconds: 2),
  );

  if (!mounted) return;

  Navigator.pushReplacementNamed(
    context,
    '/login',
  );
}

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF00506B),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(
              painter: TortoGoBackgroundPainter(),
            ),

            Center(
              child: Image.asset(
                'assets/images/tortigo_logo.png',
                width: MediaQuery.of(context).size.width * 0.78,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TortoGoBackgroundPainter extends CustomPainter {
  const TortoGoBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // =========================================================
    // FONDO PRINCIPAL
    // =========================================================

    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF006080),
          Color(0xFF004A69),
          Color(0xFF003D5B),
        ],
        stops: [
          0.0,
          0.55,
          1.0,
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      backgroundPaint,
    );

    // =========================================================
    // MANCHA SUPERIOR IZQUIERDA
    // =========================================================

    final topBlob = Path();

    topBlob.moveTo(0, 0);

    topBlob.lineTo(
      size.width * 0.38,
      0,
    );

    topBlob.cubicTo(
      size.width * 0.38,
      size.height * 0.045,
      size.width * 0.36,
      size.height * 0.065,
      size.width * 0.31,
      size.height * 0.080,
    );

    topBlob.cubicTo(
      size.width * 0.23,
      size.height * 0.105,
      size.width * 0.19,
      size.height * 0.150,
      size.width * 0.14,
      size.height * 0.185,
    );

    topBlob.cubicTo(
      size.width * 0.09,
      size.height * 0.220,
      size.width * 0.04,
      size.height * 0.230,
      0,
      size.height * 0.235,
    );

    topBlob.close();

    final topBlobPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFAFCBFF),
          Color(0xFF8FB8FF),
          Color(0xFF719DF4),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width * 0.40,
          size.height * 0.25,
        ),
      );

    canvas.drawPath(
      topBlob,
      topBlobPaint,
    );

    // =========================================================
    // LÍNEA DECORATIVA INFERIOR
    // =========================================================

    final linePath = Path();

    linePath.moveTo(
      size.width * 0.48,
      size.height,
    );

    linePath.cubicTo(
      size.width * 0.49,
      size.height * 0.94,
      size.width * 0.55,
      size.height * 0.91,
      size.width * 0.62,
      size.height * 0.89,
    );

    linePath.cubicTo(
      size.width * 0.73,
      size.height * 0.85,
      size.width * 0.76,
      size.height * 0.78,
      size.width * 0.80,
      size.height * 0.73,
    );

    linePath.cubicTo(
      size.width * 0.87,
      size.height * 0.65,
      size.width * 0.92,
      size.height * 0.63,
      size.width,
      size.height * 0.62,
    );

    final linePaint = Paint()
      ..color = const Color(0xFF6399DA).withValues(
        alpha: 0.55,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      linePath,
      linePaint,
    );

    // =========================================================
    // MANCHA INFERIOR DERECHA
    // =========================================================

    final bottomBlob = Path();

    bottomBlob.moveTo(
      size.width * 0.58,
      size.height,
    );

    bottomBlob.cubicTo(
      size.width * 0.59,
      size.height * 0.96,
      size.width * 0.62,
      size.height * 0.94,
      size.width * 0.67,
      size.height * 0.925,
    );

    bottomBlob.cubicTo(
      size.width * 0.76,
      size.height * 0.90,
      size.width * 0.79,
      size.height * 0.86,
      size.width * 0.84,
      size.height * 0.82,
    );

    bottomBlob.cubicTo(
      size.width * 0.90,
      size.height * 0.77,
      size.width * 0.95,
      size.height * 0.76,
      size.width,
      size.height * 0.76,
    );

    bottomBlob.lineTo(
      size.width,
      size.height,
    );

    bottomBlob.close();

    final bottomBlobPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF97BDFF),
          Color(0xFF719DF4),
          Color(0xFF547DD9),
        ],
      ).createShader(
        Rect.fromLTWH(
          size.width * 0.55,
          size.height * 0.75,
          size.width * 0.45,
          size.height * 0.25,
        ),
      );

    canvas.drawPath(
      bottomBlob,
      bottomBlobPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}