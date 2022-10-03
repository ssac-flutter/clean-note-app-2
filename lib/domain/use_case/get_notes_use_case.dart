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
    noteOrder.when(
      title: (orderType) {},
      date: (orderType) {},
      color: (orderType) {},
    );

    List<Note> notes = await repository.getNotes();

    notes.sort((a, b) => -a.timestamp.compareTo(b.timestamp));
    return notes;
  }
}
