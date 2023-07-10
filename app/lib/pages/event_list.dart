import 'package:flutter/material.dart';
import 'package:app/db/supabase.dart';
import 'package:go_router/go_router.dart';

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
  
  final _dataStream = supabase.from('events').stream(primaryKey: ['id']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _dataStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final events = snapshot.data!;
      
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(
                  event['id']
                  ),
                onTap: () {
                  GoRouter.of(context).go('/events/${event['id']}');
                },
              );
            }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TODO: Add new event
          // GoRouter.of(context).go('/events/new');
        },
        child: const Icon(Icons.add),
      )
    );
  }
}
