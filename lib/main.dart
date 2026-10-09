import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DashboardData(),
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DashboardScreen(),
      ),
    ),
  );
}

class DashboardData extends ChangeNotifier {
  final String _totalTime = "35h 67m";

  String get totalTime => _totalTime;

  bool _isSaved = true;

  bool get isSaved => _isSaved;

  final double _rustPercent = 0.43;

  double get rustPercent => _rustPercent;

  final double _tsPercent = 0.35;

  double get tsPercent => _tsPercent;

  void toggleSaved() {
    _isSaved = !_isSaved;
    notifyListeners();
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              // Controls how far one can pan.
              // A huge boundary will let them drag way off screen. So we aovid that
              boundaryMargin: const EdgeInsets.all(500),

              // setting 1 will DISABLE pan and zoom with locked scaling
              minScale: 0.5,
              maxScale: 3.0,

              child: SizedBox(
                // decent size ig
                width: 2000,
                height: 2000,
                child: CustomPaint(painter: MetroMapBgPainter()),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProgressiveBlur(height: 200, blurIntensity: 12.0),
          ),
          Positioned(
            top: 80,
            left: 20,
            right: 0,
            child: Consumer<DashboardData>(
              builder: (context, data, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.totalTime,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2.5,
                      height: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF00E5FF),
                        Color(0xFF2979FF),
                        Color(0xFFD500F9),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      "THIS WEEK",
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                        height: 1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 240,
            left: 20,
            child: Consumer<DashboardData>(
              builder: (context, data, _) => GlassyBoi(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: data.isSaved
                                ? const Color(0xFF00FF66)
                                : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          data.isSaved ? "main.py" : "another.py",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Last seen 2m ago",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 360,
            left: 50,
            child: GlassyBoi(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: const [
                  Icon(Icons.insert_drive_file_outlined, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "src/main.rs",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 320,
            right: 30,
            child: GlassyBoi(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: const [
                  Icon(Icons.code, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "feat: dummy UI",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "on wip/UI",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 240,
            left: 20,
            child: GlassyBoi(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "1,240 Lines",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF66).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.build_circle,
                          size: 16,
                          color: Colors.green[800],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "92% complete",
                          style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 220,
            right: 20,
            child: Consumer<DashboardData>(
              builder: (context, data, _) => GlassyBoi(
                child: Row(
                  children: [
                    _buildRing(
                      "Rust",
                      data.rustPercent,
                      const Color(0xFFFFA726),
                    ),
                    const SizedBox(width: 16),
                    _buildRing("TS", data.tsPercent, const Color(0xFF448AFF)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 130,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => context.read<DashboardData>().toggleSaved(),
                child: Container(
                  height: 64,
                  width: 224,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B5BFF),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2B5BFF).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 24),
                      const Text(
                        "Leaderboard",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: 48,
                        height: 48,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.code, color: Color(0xFF4C3BFF), size: 28),
                  Icon(Icons.terminal, color: Colors.black87, size: 28),
                  Icon(
                    Icons.desktop_windows_outlined,
                    color: Colors.black87,
                    size: 28,
                  ),
                  Icon(
                    Icons.settings_outlined,
                    color: Colors.black87,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRing(String name, double val, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                value: val,
                strokeWidth: 6,
                color: color,
                backgroundColor: color.withValues(alpha: 0.2),
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              "${(val * 100).toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ],
    );
  }
}

class GlassyBoi extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassyBoi({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class MetroMapBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    paint.color = const Color(0xFFB140FF);
    canvas.drawLine(
      Offset(size.width * 0.55, size.height * 0.3),
      Offset(size.width * 0.55, size.height),
      paint,
    );

    paint.color = const Color(0xFFFF4081);
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.5),
      paint,
    );

    paint.color = const Color(0xFF00FF66);
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.65, size.height * 0.5),
      paint,
    );

    paint.color = const Color(0xFF2979FF);
    final bluePath = Path()
      ..moveTo(size.width * 0.65, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.5,
        size.width * 0.9,
        size.height * 0.4,
      )
      ..lineTo(size.width * 0.9, size.height * 0.3);
    canvas.drawPath(bluePath, paint);

    paint.color = const Color(0xFFFFA726);
    final orangePath = Path()
      ..moveTo(size.width * 0.55, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.65,
        size.width * 0.4,
        size.height * 0.75,
      )
      ..lineTo(size.width * 0.4, size.height * 0.85);
    canvas.drawPath(orangePath, paint);

    final nodePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    void drawNode(Offset pos, Color color) {
      strokePaint.color = color;
      canvas.drawCircle(pos, 8, nodePaint);
      canvas.drawCircle(pos, 8, strokePaint);
    }

    drawNode(
      Offset(size.width * 0.4, size.height * 0.5),
      const Color(0xFFFF4081),
    );
    drawNode(
      Offset(size.width * 0.55, size.height * 0.5),
      const Color(0xFF00FF66),
    );
    drawNode(
      Offset(size.width * 0.55, size.height * 0.65),
      const Color(0xFFB140FF),
    );
    drawNode(
      Offset(size.width * 0.9, size.height * 0.3),
      const Color(0xFF2979FF),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/* Reusable widget for the progressive blurs */
class ProgressiveBlur extends StatelessWidget {
  final double height;
  final double blurIntensity;

  const ProgressiveBlur({
    super.key,
    this.height = 100,
    this.blurIntensity = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.transparent],
            stops: [0.3, 1.0],
          ).createShader(bounds);
        },

        blendMode: BlendMode.dstIn,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity,
          ),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }
}
