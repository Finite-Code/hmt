import 'package:flutter/material.dart';

import 'deathboard.dart'; // the leaderboard screen yk

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: GlitchDash()),
);

class GlitchDash extends StatefulWidget {
  const GlitchDash({super.key});

  @override
  State<GlitchDash> createState() => _GlitchDashState();
}

class _GlitchDashState extends State<GlitchDash> {
  // hey babe does it make sense? F*(# NO!
  final int totalSecs = 126720;
  bool isDraft = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050000), // cause it's 3AM?
      body: Stack(
        children: [
          // Gritty grid bg
          Positioned.fill(child: CustomPaint(painter: GridPainter())),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "HMT.TRACKING //",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // main time block
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF003C), Color(0x90AA0000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Text(
                      "35h 67m",
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -3,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const Text(
                    "THIS_WEEK",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // status area
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                      color: Colors.red.withValues(alpha: 0.05),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          color: isDraft
                              ? Colors.yellow
                              : const Color(0xFFFF003C),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isDraft ? "STALE" : "2m ago",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // targets
                  _buildTarget("src/main.rs", "git: HEAD"),
                  const SizedBox(height: 12),
                  _buildTarget("lib/core.dart", "git: WIP"),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBlock("LINES", "1,240"),
                      _buildStatBlock("RUST", "43%"),
                      _buildStatBlock("TS", "35%"),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Action button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaderboardScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF003C),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'team ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: 'death',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextSpan(text: ' board'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // fake scanline overlay
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.red.withValues(alpha: 0.03),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarget(String file, String branch) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFFFF003C), width: 4)),
        color: Color(0xFF110000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            file,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            branch,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBlock(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFF003C),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    // draw the grid lines manually :)
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
