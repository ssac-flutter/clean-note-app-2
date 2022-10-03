import 'package:clean_note_app_2/data/data_source/note_db_helper.dart';
import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Init ffi loader if needed.
  sqfliteFfiInit();

    test('db test', () async {
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute('''
    CREATE TABLE note (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        color INTEGER,
        timestamp INTEGER
    )
    ''');

      final noteDbHelper = NoteDbHelper(db);
      await noteDbHelper.insertNote(const Note(
        title: 'test',
        content: 'test',
        color: 1,
        timestamp: 1,
      ));

      expect((await noteDbHelper.getNotes()).length, 1);

      // getNoteById(int id) : int? id는 널러블이기에, 널체크 해줘야 함
      Note note = (await noteDbHelper.getNoteById(1))!;
      expect(note.id, 1);

      // updateNote(Note note) : freezed note는 불변객체이기에 copyWith()로 수정 후
      // note를 호출 후 test한다
      await noteDbHelper.updateNote(note.copyWith(
        title: 'change',
      ));
      note = (await noteDbHelper.getNoteById(1))!;
      expect(note.title, 'change');

      await noteDbHelper.deleteNote(note);
      expect((await noteDbHelper.getNotes()).length, 0);

      await db.close();
    });
}
