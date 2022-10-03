import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:clean_note_app_2/domain/repository/note_repository.dart';
import 'package:clean_note_app_2/domain/util/note_order.dart';

// enum NoteOrder { title, date, color }
// enum OrderType { ascending, descending }

class GetNotesUseCase {
  // note_repository 인터페이스 활용하여, 모든 메서드가 가지고 있는 call() 메서드 재정의 한다
  // view_model에서 사용하는 repository는 삭제한다

  final NoteRepository repository;

  GetNotesUseCase(this.repository);

  // const factory NoteOrder.title(OrderType orderType)
  Future<List<Note>> call(NoteOrder noteOrder) async {
    List<Note> notes = await repository.getNotes();

    // NotesState에 NoteOrder 상태추가 => viewModel에 넘겨준다
    noteOrder.when(
      title: (orderType) {
        orderType.when(
          ascending: () {
            notes.sort((a, b) => a.title.compareTo(b.title));
          },
          descending: () {
            notes.sort((a, b) => -a.title.compareTo(b.title));
          },
        );

      },
      date: (orderType) {
        orderType.when(
          ascending: () {
            notes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          },
          descending: () {
            notes.sort((a, b) => -a.timestamp.compareTo(b.timestamp));
          },
        );
      },
      color: (orderType) {
        orderType.when(
          ascending: () {
            notes.sort((a, b) => a.color.compareTo(b.color));
          },
          descending: () {
            notes.sort((a, b) => -a.color.compareTo(b.color));
          },
        );
      },
    );


    return notes;
  }
}
