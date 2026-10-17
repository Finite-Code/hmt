import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'bcknd/web_clerk.dart';
import 'time.dart';
import 'welcome.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  int? streak;
  double? totalSeconds;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final me = await WebClerk.me();
    final s = await WebClerk.streakDays();
    final hrs = await WebClerk.loggedHours();

    if (!mounted) return;
    setState(() {
      userData = me;
      streak = s;
      totalSeconds = hrs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final alias = userData?['github_username'] ?? userData?['slack_id'] ?? '0xATHARVA';
    final streakText = "${streak ?? 14} DAYS";
    final totalTimeText = formatSeconds(totalSeconds ?? 513000);

    return Scaffold(
      backgroundColor: const Color(0xFF050000),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                    "USER_PROFILE //",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Alias block
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFF003C),
                    width: 1.5,
                  ),
                  color: const Color(0xFF110000),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFF003C),
                          width: 2,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://i.pravatar.cc/100?img=67",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alias,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          color: const Color(0xFFFF003C),
                          child: const Text(
                            "#1 GLOBAL",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "METRICS_OVERVIEW",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard("STREAK", streakText),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard("DAILY_AVG", "5h 12m"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard("TOTAL_TIME", totalTimeText),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard("MAIN_LANG", "RUST"),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white12),
                  color: Colors.white.withValues(alpha: 0.02),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "SESSION",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      "ACTIVE // AES-256",
                      style: TextStyle(
                        color: Color(0xFFFF003C),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () async {
                  await TokenStorage.logout();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WelcomeScareScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color(0xFFFF003C),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "PURGE_SESSION // LOGOUT",
                      style: TextStyle(
                        color: Color(0xFFFF003C),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String val) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFFFF003C), width: 3)),
        color: Color(0xFF110000),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            val,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFF003C),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
