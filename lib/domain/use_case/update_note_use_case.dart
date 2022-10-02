import '../model/note.dart';
import '../repository/note_repository.dart';

class UpdatNoteUseCase {
  final NoteRepository repository;

  UpdatNoteUseCase(this.repository);

  Future<void> call(Note note) async {
    await repository.updateNote(note);
  }
}