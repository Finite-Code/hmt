import 'package:flutter/material.dart';

void main() {
  runApp(const HackatimeApp());
}

class HackatimeApp extends StatelessWidget {
  const HackatimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hack\'d my time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String _clientId = 'HACKATIME_CLIENT_ID';
  static const String _redirectUri = 'hackedmytime://oauth2redirect';
  static const String _authorizationEndpoint = 'https://waka.hackclub.com/oauth/authorize';
  static const String _tokenEndpoint = 'https://waka.hackclub.com/oauth/token';

  Future<void> _handleLogin(BuildContext context) async {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demo login succeeds ig...')),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DummyDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.dangerous_outlined,
                  size: 100,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 40),

              const Text(
                'They hacked my time...',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Log in with your Hack Club account to view your stats. and get your\'s hacked too',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 60),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _handleLogin(context),
                  icon: const Icon(Icons.login_rounded),
                  label: const Text(
                    'Login with Hackatime?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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

class DummyDashboardScreen extends StatelessWidget {
  const DummyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OAuth Successful!\nDashboard UI goes here...',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}