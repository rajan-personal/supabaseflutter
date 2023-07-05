import 'package:app/pages/event_list.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://tnxjgdzsvffqubrattzm.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRueGpnZHpzdmZmcXVicmF0dHptIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODY3MjM2OTEsImV4cCI6MjAwMjI5OTY5MX0.ONb25YSgrApJISU3ix34nIg7zsTrIC39gkPioEwwj14",
  );
  // runApp(const SignUpApp());
  runApp(const HomeRoutes());
}

class HomeRoutes extends StatelessWidget {
  const HomeRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const EventList(),
      },
    );
  }
}