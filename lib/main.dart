import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initError;
  try {
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  } catch (e) {
    initError = e.toString();
  }
  runApp(ThreadgramApp(initError: initError));
}

class ThreadgramApp extends StatelessWidget {
  final String? initError;
  const ThreadgramApp({super.key, this.initError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Threadgram',
      theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
      home: initError != null
          ? ErrorScreen(error: initError!)
          : const AuthEntryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Error screen to show what went wrong
class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text('Initialization Failed', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text(error, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

// --- The rest of your AuthEntryScreen, AccountCompletionScreen, etc. ---
// (Keep all the code below unchanged. I will repeat it for completeness.)

class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key});

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback/',
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _continueWithEmail() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }
    setState(() => _isLoading = true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountCompletionScreen(email: _emailController.text),
      ),
    );
    setState(() => _isLoading = false);
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
              _buildSocialButton('Continue with Apple', () => _showComingSoon()),
              _buildSocialButton('Continue with Facebook', () => _showComingSoon()),
              _buildSocialButton('Continue with Google', _signInWithGoogle),
              const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('OR')), Expanded(child: Divider())]),
              const SizedBox(height: 20),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email address', border: OutlineInputBorder())),
              const SizedBox(height: 20),
              if (_isLoading) const CircularProgressIndicator() else ElevatedButton(onPressed: _continueWithEmail, child: const Text('Continue')),
              TextButton(onPressed: () => _showComingSoon(), child: const Text('Forgot Password?')),
              const SizedBox(height: 20),
              const Text('English'),
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

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming Soon!')));
  }
}

class AccountCompletionScreen extends StatefulWidget {
  final String email;
  const AccountCompletionScreen({super.key, required this.email});

  @override
  State<AccountCompletionScreen> createState() => _AccountCompletionScreenState();
}

class _AccountCompletionScreenState extends State<AccountCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _agreeToTerms = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate() || !_agreeToTerms) return;
    setState(() => _isLoading = true);
    try {
      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: widget.email,
        password: _passwordController.text,
        data: {'first_name': _firstNameController.text, 'last_name': _lastNameController.text},
      );
      if (res.user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegionSelectionScreen()));
      } else {
        throw Exception('Sign-up failed');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign-up failed: $error')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First name'), validator: (value) => value!.isEmpty ? 'Required' : null),
              TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last name'), validator: (value) => value!.isEmpty ? 'Required' : null),
              TextFormField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: (value) => value!.length < 6 ? 'Password too short' : null),
              Row(children: [Checkbox(value: _agreeToTerms, onChanged: (val) => setState(() => _agreeToTerms = val!)), const Expanded(child: Text('I agree to the Privacy Policy, Terms of Use and Terms of Service'))]),
              const SizedBox(height: 20),
              if (_isLoading) const CircularProgressIndicator() else ElevatedButton(onPressed: _signUp, child: const Text('Continue')),
            ],
          ),
        ),
      ),
    );
  }
}

class RegionSelectionScreen extends StatelessWidget {
  const RegionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Region')),
      body: const Center(child: Text('Region Selection Screen - Coming Soon!')),
    );
  }
}
