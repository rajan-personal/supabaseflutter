import 'package:app/pages/event_details.dart';
import 'package:app/pages/event_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://tnxjgdzsvffqubrattzm.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRueGpnZHpzdmZmcXVicmF0dHptIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODY3MjM2OTEsImV4cCI6MjAwMjI5OTY5MX0.ONb25YSgrApJISU3ix34nIg7zsTrIC39gkPioEwwj14",
  );
  // runApp(const SignUpApp());
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const EventList();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'event/:id',
          builder: (BuildContext context, GoRouterState state) {
            return EventDetails(id: state.pathParameters['id']);
          },
        ),
      ],
    ),
  ],
);

