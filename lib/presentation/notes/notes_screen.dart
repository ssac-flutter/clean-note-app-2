import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:clean_note_app_2/presentation/notes/components/note_item.dart';
import 'package:clean_note_app_2/ui/colors.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your note', style: TextStyle(fontSize: 30),),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort),
          ),
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder:(context) => const AddEditNoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
         // NoteItem({Key? key, required this.note, this.onDeleteTap,}) : super(key: key);
            NoteItem(
              note: Note(
                title: 'title1',
                content: 'content1',
                color: wisteria.value,
                timestamp: 1,
              ),
            ),
            NoteItem(
              note: Note(
                title: 'title2',
                content: 'content2',
                color: skyBlue.value,
                timestamp: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
