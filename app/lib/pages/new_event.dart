import 'package:app/db/supabase.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rate_limiter/rate_limiter.dart';

class NewEvent extends StatelessWidget {
  const NewEvent({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'New Event';

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: const NewEventForm(),
    );
  }
}

// Create a Form widget.
class NewEventForm extends StatefulWidget {
  const NewEventForm({super.key});

  @override
  NewEventFormState createState() {
    return NewEventFormState();
  }
}

class NewEventFormState extends State<NewEventForm> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Description"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: Debounce(() async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    await supabase.from('events').insert({
                        'title': title,
                        'description': description
                    });
                    GoRouter.of(context).go('/events');
                  }
                }, const Duration(seconds: 2)),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}