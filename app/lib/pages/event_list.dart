import 'package:flutter/material.dart';
import 'package:app/db/supabase.dart';

import 'event_details.dart';

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
      ),
      body: const EventListElements()
    );
  }
}

class EventListElements extends StatefulWidget {
  const EventListElements({super.key});

  @override
  State<EventListElements> createState() => _EventListElementsState();
}



class _EventListElementsState extends State<EventListElements> {
  
  final _notesStream = supabase.from('events').stream(primaryKey: ['id']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                title: Text(
                  notes[index]['id']
                  ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventDetails(id: notes[index]['id'])),
                  );
                },
              );
            }
          );
        },
      )
    );
  }
}
