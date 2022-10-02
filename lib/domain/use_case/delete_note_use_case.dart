import 'package:clean_note_app_2/domain/model/note.dart';

import '../repository/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository repository;

  DeleteNoteUseCase(this.repository);

  // note_repository 인터페이스 활용하여, 모든 메서드가 가지고 있는 call() 메서드 재정의 한다
  Future<void> call(Note note) async {
    await repository.deleteNote(note);
  }
}