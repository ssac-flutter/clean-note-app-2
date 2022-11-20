import 'package:clean_note_app_2/di/di_setup.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:clean_note_app_2/presentation/notes/components/note_item.dart';
import 'package:clean_note_app_2/presentation/notes/components/order_section.dart';
import 'package:clean_note_app_2/presentation/notes/notes_event.dart';
import 'package:clean_note_app_2/presentation/notes/notes_view_model.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt.get<NotesViewModel>(),
      builder: (context, widget) {
        final viewModel = context.watch<NotesViewModel>();
        final state = viewModel.state;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              '운세 노트',
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
                            viewModel
                                .onEvent(NotesEvent.changeOrder(noteOrder));
                          },
                        )
                      : Container(),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.yMMMMd().format(DateTime.now().toLocal()),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '오늘의 운세',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          bool? isSaved = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ChangeNotifierProvider(
                                  create: (_) =>
                                      getIt.get<AddEditNoteViewModel>(),
                                  child: const AddEditNoteScreen(),
                                );
                              },
                            ),
                          );

                          if (isSaved != null && isSaved) {
                            viewModel.onEvent(const NotesEvent.loadNotes());
                          }
                        },
                        child: const Text("+ 노트 추가"),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  child: DatePicker(
                    DateTime.now().toLocal(),
                    height: 100,
                    width: 80,
                    initialSelectedDate: DateTime.now().toLocal(),
                    selectionColor: Colors.black87,
                    selectedTextColor: Colors.white,
                    dateTextStyle: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    dayTextStyle: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    monthTextStyle: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    // Today 날짜 선택하면, 입력된 데이터 호출!!
                    onDateChange: (date) {
                      viewModel.dateChanged(date);
                    },
                  ),
                ),
                ...state.notes
                    .map((note) => GestureDetector(
                          onTap: () async {
                            bool? isSaved = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChangeNotifierProvider(
                                    // factory로 새로 생성해서 전달 & ..setNote 값을 함께 전달함
                                    create: (_) =>
                                        getIt.get<AddEditNoteViewModel>()
                                          ..setNote(note),
                                    child: AddEditNoteScreen(note: note),
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
                                content: const Text('노트가 삭제됩니다'),
                                action: SnackBarAction(
                                  label: '취소',
                                  onPressed: () {
                                    viewModel.onEvent(
                                        const NotesEvent.restoreNote());
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     bool? isSaved = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return ChangeNotifierProvider(
          //             create: (_) => getIt.get<AddEditNoteViewModel>(),
          //             child: const AddEditNoteScreen(),
          //           );
          //         },
          //       ),
          //     );
          //
          //     if (isSaved != null && isSaved) {
          //       viewModel.onEvent(const NotesEvent.loadNotes());
          //     }
          //   },
          //   child: const Icon(Icons.add),
          // ),

        );
      },
    );
  }

// _addTaskBar() {
//   return Container(
//     margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               DateFormat.yMMMMd().format(DateTime.now()),
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               'Today',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         ElevatedButton(onPressed: () async {
//           bool? isSaved = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) {
//                 return ChangeNotifierProvider(
//                   create: (_) => getIt.get<AddEditNoteViewModel>(),
//                   child: const AddEditNoteScreen(),
//                 );
//               },
//             ),
//           );
//
//           if (isSaved != null && isSaved) {
//             viewModel.onEvent(const NotesEvent.loadNotes());
//           }
//         },
//           child: const Text("+ Add Task"),
//         ),
//       ],
//     ),
//   );
// }

}
