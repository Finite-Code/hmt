import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart'; // to route to the dash

class WelcomeScareScreen extends StatefulWidget {
  const WelcomeScareScreen({super.key});

  @override
  State<WelcomeScareScreen> createState() => _WelcomeScareScreenState();
}

class _WelcomeScareScreenState extends State<WelcomeScareScreen> {
  bool showSecondaryWarn = false; // the great glitchy bool you fool

  @override
  void initState() {
    super.initState();
    // delay the second warning to creep 'em out
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => showSecondaryWarn = true);
        _triggerGlitchHaptic(); // <--- ZAP!
      }
    });
  }

  Future<void> _triggerGlitchHaptic() async {
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 20));

    for (int i = 0; i < 5; i++) {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 10));
    }

    await Future.delayed(const Duration(milliseconds: 40));
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 20));
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030000),
      // this is darker than the dash itself, which makes me wonder what out of two should be darker? or if even equal
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "UNAUTHORIZED_ACCESS",
                style: TextStyle(
                  color: Color(0xFFFF003C),
                  fontSize: 28,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                "YOU ARE ABOUT TO EXPOSE YOUR INTERNAL METRICS TO A HOSTILE ENVIRONMENT.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Every second of your time will be scraped, aggregated, and matched against others. Your incompetency will be visible.\n\nBy continuing you consent Team Blackwell to exploit, store and modify any such metrics.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'monospace',
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              if (showSecondaryWarn)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    border: Border.all(
                      color: const Color(0xFFFF003C),
                      width: 1.5,
                    ),
                  ),
                  child: const Text(
                    "WARNING: CONSTRUCT INJECTION DETECTED.\nTHE MONOGRAM MAY KILL THE CLIENT. ABORTING.",
                    style: TextStyle(
                      color: Color(0xFFFF003C),
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                const SizedBox(height: 60),
              // keep layout stable before warn pops

              const Spacer(),

              // the "leave" btn (safe)
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Connection terminated. Stay safe sucker',
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                    ), // TODO: just show a snackbar for now and uhh it looks ugly so fix it later
                  );
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white38),
                  ),
                  child: const Center(
                    child: Text(
                      "TERMINATE",
                      style: TextStyle(
                        color: Colors.white54,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // the "enter" btn (supposed to be dangerous)
              GestureDetector(
                onTap: () async {
                  await _triggerGlitchHaptic(); // <--- Glitch before moving

                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GlitchDash()),
                  );
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF110000),
                    border: Border.all(
                      color: const Color(0xFFFF003C),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "SIGN IN WITH 鏡 ニューラル",
                      // TODO: Start the Oauth process and uhh maybe keep the japanese company name to make a lore out of it
                      style: TextStyle(
                        color: Color(0xFFFF003C),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.1,
                        fontFamily: 'monospace',
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
    );
  }
}
