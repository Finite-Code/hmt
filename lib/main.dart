import 'package:flutter/material.dart';
import 'package:hackedmytime/auth_service.dart';
import 'package:hackedmytime/bcknd/web_clerk.dart';
import 'package:hackedmytime/deathboard.dart';
import 'package:hackedmytime/time.dart';
import 'package:hackedmytime/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // don't render anything if not logged in!
  final bool loggedIn = await TokenStorage.isLoggedIn();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // If logged in go to dashboard or login first xD
      home: loggedIn ? const GlitchDash() : const WelcomeScareScreen(),
    ),
  );
}

class GlitchDash extends StatefulWidget {
  const GlitchDash({super.key});

  @override
  State<GlitchDash> createState() => _GlitchDashState();
}

class _GlitchDashState extends State<GlitchDash> {
  // hey babe does it make sense? F*(# NO!
  double? totalSecs;
  String lastSeenText = "2m ago";
  String activeFile = "src/main.rs";
  String activeBranch = "git: HEAD";
  List<dynamic> languages = [];
  bool isDraft = false;

  @override
  void initState() {
    super.initState();
    _loadDashData();
  }

  Future<void> _loadDashData() async {
    final hrs = await WebClerk.loggedHours();
    final beat = await WebClerk.latestBeat();
    final stats = await WebClerk.weeklyStats();

    if (!mounted) return;
    setState(() {
      totalSecs = hrs;
      if (beat.containsKey('time_ago')) {
        lastSeenText = beat['time_ago'] ?? "2m ago";
        final hb = beat['heartbeat'];
        if (hb != null && hb['entity'] != null) {
          activeFile = hb['entity'].toString().split('/').last;
          activeBranch = "git: ${hb['branch'] ?? 'HEAD'}";
        }
      }
      if (stats.containsKey('languages') && stats['languages'] != null) {
        languages = stats['languages'] as List<dynamic>;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang1 = languages.isNotEmpty
        ? languages[0]['name'].toString().toUpperCase()
        : "RUST";
    final pct1 = languages.isNotEmpty
        ? "${(languages[0]['percent'] ?? 43).round()}%"
        : "43%";
    final lang2 = languages.length > 1
        ? languages[1]['name'].toString().toUpperCase()
        : "TS";
    final pct2 = languages.length > 1
        ? "${(languages[1]['percent'] ?? 35).round()}%"
        : "35%";

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
                    child: Text(
                      formatSeconds(totalSecs ?? 126720),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -3,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const Text(
                    "* THIS WEEK",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

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
                          isDraft ? "STALE" : lastSeenText,
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
                  _buildTarget(activeFile, activeBranch),
                  const SizedBox(height: 12),
                  _buildTarget("lib/core.dart", "git: WIP"),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBlock("LINES", "*@&#"),
                      _buildStatBlock("RUST", "XY%"),
                      _buildStatBlock("TS", "YX%"),
                    ],
                  ),

                  const SizedBox(height: 40),

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
      ..color = Colors.white24
      ..strokeWidth = 1;

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
