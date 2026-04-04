import 'package:flutter/material.dart';

void main() => runApp(const ThreadgramApp());

class ThreadgramApp extends StatelessWidget {
  const ThreadgramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Threadgram',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            // Threadgram logo with eBay-style colors
            const ColoredLetterLogo(),
            const Spacer(flex: 4),
            // Get Started button - glass morphism
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                },
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 1.0, end: 1.0),
                  duration: const Duration(milliseconds: 100),
                  builder: (context, double scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937), // gray-900
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class ColoredLetterLogo extends StatelessWidget {
  const ColoredLetterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    const letters = [
      {'char': 'T', 'color': Color(0xFFe53238)}, // red
      {'char': 'h', 'color': Color(0xFF0064d2)}, // blue
      {'char': 'r', 'color': Color(0xFFf5af02)}, // yellow
      {'char': 'e', 'color': Color(0xFF0064d2)}, // blue
      {'char': 'a', 'color': Color(0xFF86b817)}, // green
      {'char': 'd', 'color': Color(0xFFe53238)}, // red
      {'char': 'g', 'color': Color(0xFF0064d2)}, // blue
      {'char': 'r', 'color': Color(0xFFf5af02)}, // yellow
      {'char': 'a', 'color': Color(0xFF0064d2)}, // blue
      {'char': 'm', 'color': Color(0xFF86b817)}, // green
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) {
        return Text(
          letter['char'] as String,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: letter['color'] as Color,
            letterSpacing: -1,
          ),
        );
      }).toList(),
    );
  }
}

// Temporary placeholder – will be replaced with real Supabase SignUp screen
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: const Center(child: Text('Sign Up screen – coming soon!')),
    );
  }
}
