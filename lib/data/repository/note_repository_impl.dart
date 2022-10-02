import 'package:clean_note_app_2/data/data_source/note_db_helper.dart';
import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:clean_note_app_2/domain/repository/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteDbHelper db;

  NoteRepositoryImpl(this.db);

  @override
  Future<void> deleteNote(Note note) async {
    await db.deleteNote(note);
  }

  @override
  Future<Note?> getNoteById(int id) async {
    // note_repository에서 nullable로 수정. int? id로 널러블임.
    return await db.getNoteById(id);
  }

  @override
  Future<List<Note>> getNotes() async{
    return await db.getNotes();
  }

  @override
  Future<void> insertNote(Note note) async {
    await db.insertNote(note);
  }

  @override
  Future<void> updateNote(Note note) async {
    await db.updateNote(note);
  }

}