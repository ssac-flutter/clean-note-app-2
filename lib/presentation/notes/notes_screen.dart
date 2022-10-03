import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:clean_note_app_2/presentation/notes/components/note_item.dart';
import 'package:clean_note_app_2/presentation/notes/notes_view_model.dart';
import 'package:clean_note_app_2/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesViewModel>();
    // state에는 notes 데이터가 들어있고, ListView에서 map()으로 NoteItem()에 뿌려줌
    final state = viewModel.state;

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
          children:
          // NoteItem({Key? key, required this.note, this.onDeleteTap,})
            state.notes.map((note) =>NoteItem(
              note: note,
            ) ).toList(),
        ),
      ),
    );
  }
}
