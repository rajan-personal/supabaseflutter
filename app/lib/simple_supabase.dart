import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://tnxjgdzsvffqubrattzm.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRueGpnZHpzdmZmcXVicmF0dHptIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODY3MjM2OTEsImV4cCI6MjAwMjI5OTY5MX0.ONb25YSgrApJISU3ix34nIg7zsTrIC39gkPioEwwj14",
  );
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyWidget',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home1(title: 'MyWidget'),
    );
  }
}

class Home1 extends StatefulWidget {
  const Home1 ({super.key, required this.title});

  final String title;

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {

  final _notesStream = Supabase.instance.client.from('flutter_notes').stream(primaryKey: ['id']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notes[index]['body']),
              );
            }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: ((context) {
            return SimpleDialog(
              title: const Text('Dialog'),
              children: [
                TextFormField(
                  onFieldSubmitted: (value) async {
                    await Supabase.instance.client.from('flutter_notes').insert(
                      {'body': value});
                  },
                )
              ],
            );
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}