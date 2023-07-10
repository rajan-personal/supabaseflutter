import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../db/supabase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final Session? session = supabase.auth.currentSession;
  @override
  Widget build(BuildContext context) {
    if (session != null) {
      GoRouter.of(context).go('/events');
    }
    return const Login();
  }
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await supabase.auth.signInWithOAuth(Provider.google);
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}