import 'package:flutter/material.dart';
import 'bcknd/web_clerk.dart';
import 'time.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> apiHackers = [];
  String selectedFilter = "GLOBAL";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final list = await WebClerk.topHackers();
    if (!mounted) return;
    setState(() {
      apiHackers = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> fallback = [
      {"name": "0xATHARVA", "time": "35h 67m", "lang": "RUST"},
      {"name": "GHOST_SEC", "time": "29h 14m", "lang": "C"},
      {"name": "NULL_PTR", "time": "24h 02m", "lang": "TS"},
      {"name": "VOID_MAIN", "time": "18h 45m", "lang": "DART"},
      {"name": "SYN_ACK", "time": "12h 10m", "lang": "PYTHON"},
      {"name": "SYS_ADMIN", "time": "08h 55m", "lang": "BASH"},
    ];

    final displayList = apiHackers.isNotEmpty
        ? apiHackers.map((e) {
            final u = e['user'] ?? {};
            return {
              "name": (u['username'] ?? 'ANON').toString().toUpperCase(),
              "time": formatSeconds(e['total_seconds']),
              "lang": "RUST",
            };
          }).toList()
        : fallback;

    final filtered = selectedFilter == "RUST"
        ? displayList.where((h) => h['lang'] == 'RUST').toList()
        : displayList;

    return Scaffold(
      backgroundColor: const Color(0xFF050000),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            // Category Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: ["GLOBAL", "3AM_CLUB", "RUST"].map((tag) {
                  final active = selectedFilter == tag;
                  return GestureDetector(
                    onTap: () => setState(() => selectedFilter = tag),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFFFF003C)
                            : Colors.transparent,
                        border: Border.all(
                          color: active
                              ? const Color(0xFFFF003C)
                              : Colors.white24,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: active ? Colors.black : Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

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
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final hacker = filtered[index];
                  final isMe = hacker['name'] == '0xATHARVA';

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
