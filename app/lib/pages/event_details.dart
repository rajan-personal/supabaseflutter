import 'package:flutter/material.dart';
import 'package:app/db/supabase.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key, required this.id});

  final String id;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  late Future<List?> test;
  
  Future<List?> getData() async {
    final  result = await supabase.from('events').select().eq('id', widget.id);
    return result;
  }

  @override
  void initState() {
    test = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: FutureBuilder<List?>(
        future: test,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;
          return Text(notes[0]['title']);
        },
      )
    );
  }
}