import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:app/db/supabase.dart';
import 'fullscreen_image.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key, required this.id});

  final String? id;
 
  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  late Future<List?> data;
  
  Future<List?> getData() async {
    final data = await supabase.from('links').select().eq('event_id', widget.id);
    return data;
  }

  Image getImage(String url) {
    return Image.network(url);
  }

  @override
  void initState() {
    data = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: FutureBuilder<List?>(
        future: data,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final links = snapshot.data!;
          return GridView.builder(
            itemCount: links.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), 
            itemBuilder: (_, int index) {
              final link = links[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FullscreenImage(url: link['url'])),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: getImage(link['url']),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: TextButton(
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles(
            type: FileType.image,
            allowMultiple: true,
          );
          if (result != null) {
            final files = result.files;
            for (var file in files) {
              print(file.size);
              // TODO: Upload file to Supabase Storage
            }
          }
        },
        child: const Text('Add Link'),
      )
    );
  }
}