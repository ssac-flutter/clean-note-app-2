import 'package:clean_note_app_2/domain/repository/note_repository.dart';
import 'package:clean_note_app_2/domain/util/note_order.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:clean_note_app_2/presentation/notes/components/note_item.dart';
import 'package:clean_note_app_2/presentation/notes/components/order_section.dart';
import 'package:clean_note_app_2/presentation/notes/notes_event.dart';
import 'package:clean_note_app_2/presentation/notes/notes_view_model.dart';
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
        title: const Text(
          'Your note',
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
            // 먼저 notes_event에 toggleOrderSection 추가
            onPressed: () {
              viewModel.onEvent(const NotesEvent.toggleOrderSection());
            },
            icon: const Icon(Icons.sort),
          ),
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isSaved = await Navigator.push(
            context,
            //MaterialPageRoute(
            //    builder: (context) => const AddEditNoteScreen()));
            MaterialPageRoute(
              builder: (context) {
                final repository = context.read<NoteRepository>();
                const nextScreen = AddEditNoteScreen();
                final viewModel = AddEditNoteViewModel(repository);

                return ChangeNotifierProvider(
                  create: (_) => viewModel,
                  child: nextScreen,
                );
              },
            ),
          );

          if (isSaved != null && isSaved) {
            viewModel.onEvent(const NotesEvent.loadNotes());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              // notes_state에 상태 추가 isOrderSectionVisible,
              child: state.isOrderSectionVisible
                  ? OrderSection(
                      noteOrder: state.noteOrder,
                      onOrderChanged: (noteOrder) {
                        viewModel.onEvent(NotesEvent.changeOrder(noteOrder));
                      },
                    )
                  : Container(),
            ),
            ...state.notes
                .map((note) => GestureDetector(
                      onTap: () async {
                        bool? isSaved = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              final repository = context.read<NoteRepository>();
                              final nextScreen = AddEditNoteScreen(
                                note: note,
                              );
                              final viewModel =
                                  AddEditNoteViewModel(repository, note: note);

                              return ChangeNotifierProvider(
                                create: (_) => viewModel,
                                child: nextScreen,
                              );
                            },
                            // 페이지 넘어가면, initState()에서 받아서 호출
                          ),
                        );

                        if (isSaved != null && isSaved) {
                          viewModel.onEvent(const NotesEvent.loadNotes());
                        }
                      },
                      child: NoteItem(
                        note: note,
                        onDeleteTap: () {
                          viewModel.onEvent(NotesEvent.deleteNote(note));

                          final snackBar = SnackBar(
                            content: const Text('노트가 삭제도있습니다'),
                            action: SnackBarAction(
                              label: '취소',
                              onPressed: () {
                                viewModel
                                    .onEvent(const NotesEvent.restoreNote());
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
