import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://oeilgyzkoqxhxczvighk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9laWxneXprb3F4aHhjenZpZ2hrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU0NDE4ODMsImV4cCI6MjA5MTAxNzg4M30.8SSAfqacqTnJupmWzoe_rXA_tvw7LK6wJdZWQtmIGCI',
  );
  runApp(const ThreadgramApp());
}

class ThreadgramApp extends StatelessWidget {
  const ThreadgramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Threadgram',
      theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
      home: const AuthEntryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key});

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // No custom redirectTo – Supabase will use the default deep link
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $error')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('THREADGRAM', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Log in or sign up'),
              const SizedBox(height: 40),
              _buildSocialButton('Continue with Google', _signInWithGoogle),
              const SizedBox(height: 20),
              if (_isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        child: Text(text),
      ),
    );
  }
}
