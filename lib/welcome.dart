import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'auth_config.dart';
import 'auth_service.dart';
import 'main.dart';
import 'pkce.dart';

class WelcomeScareScreen extends StatefulWidget {
  const WelcomeScareScreen({super.key});

  @override
  State<WelcomeScareScreen> createState() => _WelcomeScareScreenState();
}

class _WelcomeScareScreenState extends State<WelcomeScareScreen> {
  bool showSecondaryWarn = false; // the great glitchy bool
  bool isExchangingToken = false;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    // Intercept callback when returning from browser
    _initDeepLinks();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => showSecondaryWarn = true);
        _triggerGlitchHaptic();
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  void _initDeepLinks() {
    final appLinks = AppLinks();
    _linkSubscription = appLinks.uriLinkStream.listen((uri) async {
      if (uri.scheme == 'theyhackedmytime' && uri.host == 'oauth-callback-v1') {
        final code = uri.queryParameters['code'];
        if (code != null) {
          setState(() => isExchangingToken = true);

          final verifier = await TokenStorage.getVerifier();
          if (verifier != null) {
            final token = await AuthService.exchangeCodeForToken(
              authorizationCode: code,
              codeVerifier: verifier,
            );

            if (token != null) {
              await TokenStorage.saveToken(token);
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const GlitchDash()),
              );
              return;
            }
          }

          if (mounted) {
            setState(() => isExchangingToken = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'ERR: OAUTH_EXCHANGE_FAILED',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
            );
          }
        }
      }
    });
  }

  Future<void> _startOAuthFlow() async {
    await _triggerGlitchHaptic();

    final verifier = PkceHelper.generateCodeVerifier();
    final challenge = PkceHelper.generateCodeChallenge(verifier);

    // Save verifier to storage so it survives process restarts
    await TokenStorage.saveVerifier(verifier);

    final loginUrl = OAuthConfig.getLoginUrl(codeChallenge: challenge);
    final uri = Uri.parse(loginUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ERR: FAILED TO CONNECT',
            style: TextStyle(fontFamily: 'monospace'),
          ),
        ),
      );
    }
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
                  child: Text(
                    isExchangingToken ? "NEURAL_LINK_EXCHANGING_TOKEN..." : "WARNING: CONSTRUCT INJECTION DETECTED.\nTHE MONOGRAM MAY KILL THE CLIENT. ABORTING.",
                    style: const TextStyle(
                      color: Color(0xFFFF003C),
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                const SizedBox(height: 60),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Connection terminated. Stay safe sucker',
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
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

              GestureDetector(
                onTap: isExchangingToken ? null : _startOAuthFlow,
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
                  child: Center(
                    child: Text(
                      isExchangingToken
                          ? "AUTHENTICATING..."
                          : "SIGN IN WITH 鏡 ニューラル",
                      style: const TextStyle(
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
