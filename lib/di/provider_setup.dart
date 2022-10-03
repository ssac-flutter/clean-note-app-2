import 'package:clean_note_app_2/data/data_source/note_db_helper.dart';
import 'package:clean_note_app_2/data/repository/note_repository_impl.dart';
import 'package:clean_note_app_2/domain/repository/note_repository.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:clean_note_app_2/presentation/notes/notes_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';

// db가 먼저 작성되어야 함, main에서 getProvider()를 호출해서 사용한다
Future<List<SingleChildWidget>> getProviders() async {
  // 'note_db' : 파일명
  Database database =
      await openDatabase('note_db', version: 1, onCreate: (db, version) async {
    await db.execute('''
      CREATE TABLE note (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        color INTEGER,
        timestamp INTEGER
    )
      ''');
  });

  NoteDbHelper noteDbHelper = NoteDbHelper(database);
  NoteRepository repository = NoteRepositoryImpl(noteDbHelper);
  NotesViewModel notesViewModel = NotesViewModel(repository);
  AddEditNoteViewModel addEditNoteViewModel = AddEditNoteViewModel(repository);

  return [
    ChangeNotifierProvider(create: (_) => notesViewModel),
    ChangeNotifierProvider(create: (_) => addEditNoteViewModel)
  ];

  // db에서는 사실상 필요없게 됨
  // List<SingleChildWidget> independentModels = [];
  //
  // List<SingleChildWidget> dependentModels = [];
  //
  // List<SingleChildWidget> viewModels = [];
  //
  // List<SingleChildWidget> globalProviders = [
  //   ...independentModels,
  //   ...dependentModels,
  //   ...viewModels,
  // ];
  //
  // return globalProviders;
}
