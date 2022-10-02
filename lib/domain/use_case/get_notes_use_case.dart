import 'package:clean_note_app_2/data/repository/note_repository_impl.dart';
import 'package:clean_note_app_2/domain/model/note.dart';

import '../repository/note_repository.dart';

class GetNotesUseCase {
  // note_repository 인터페이스 활용하여, 모든 메서드가 가지고 있는 call() 메서드 재정의 한다
  final NoteRepository repository;

  GetNotesUseCase(this.repository);

  Future<List<Note>> call() async {
    List<Note> notes = await repository.getNotes();
    return notes;
  }

}