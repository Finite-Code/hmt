import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // dummy leaderboard data, assuming index is rank
    final List<Map<String, String>> hackers = [
      {"name": "0xATHARVA", "time": "35h 67m", "lang": "RUST"},
      {"name": "GHOST_SEC", "time": "29h 14m", "lang": "C"},
      {"name": "NULL_PTR", "time": "24h 02m", "lang": "TS"},
      {"name": "VOID_MAIN", "time": "18h 45m", "lang": "DART"},
      {"name": "SYN_ACK", "time": "12h 10m", "lang": "PYTHON"},
      {"name": "SYS_ADMIN", "time": "08h 55m", "lang": "BASH"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF050000),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFF003C)),
                        color: Colors.red.withValues(alpha: 0.1),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFFFF003C),
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "LEADERBOARD //",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 24,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // List Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Row(
                children: const [
                  SizedBox(
                    width: 30,
                    child: Text(
                      "./sr",
                      style: TextStyle(
                        color: Colors.white38,
                        fontFamily: 'monospace',
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "--rank",
                      style: TextStyle(
                        color: Colors.white38,
                        fontFamily: 'monospace',
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Text(
                    "--time",
                    style: TextStyle(
                      color: Colors.white38,
                      fontFamily: 'monospace',
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.red.withValues(alpha: 0.2),
              margin: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
            ),

            // Leaderboard List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                itemCount: hackers.length,
                itemBuilder: (context, index) {
                  final hacker = hackers[index];
                  final isMe = index == 0; // assuming top spot is user for now

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: isMe
                              ? const Color(0xFFFF003C)
                              : Colors.white24,
                          width: isMe ? 4 : 1,
                        ),
                      ),
                      color: isMe
                          ? Colors.red.withValues(alpha: 0.05)
                          : const Color(0xFF110000),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            "#${index + 1}",
                            style: TextStyle(
                              color: isMe
                                  ? const Color(0xFFFF003C)
                                  : Colors.white54,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hacker['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "MAIN: ${hacker['lang']}",
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          hacker['time']!,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
