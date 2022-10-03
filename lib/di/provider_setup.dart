import 'package:clean_note_app_2/data/data_source/note_db_helper.dart';
import 'package:clean_note_app_2/data/repository/note_repository_impl.dart';
import 'package:clean_note_app_2/domain/repository/note_repository.dart';
import 'package:clean_note_app_2/domain/use_case/add_note_use_case.dart';
import 'package:clean_note_app_2/domain/use_case/delete_note_use_case.dart';
import 'package:clean_note_app_2/domain/use_case/get_note_use_case.dart';
import 'package:clean_note_app_2/domain/use_case/get_notes_use_case.dart';
import 'package:clean_note_app_2/domain/use_case/update_note_use_case.dart';
import 'package:clean_note_app_2/domain/use_case/use_cases.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:clean_note_app_2/presentation/notes/notes_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

// GetIt 의존성 주입
final getIt = GetIt.I;

Future<void> setupDi() async {
  // Database database = await openDatabase(
  getIt.registerSingletonAsync(() => openDatabase(
        'note_db',
        version: 1,
        onCreate: (
          db,
          version,
        ) async {
          await db.execute('''
      CREATE TABLE note (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        color INTEGER,
        timestamp INTEGER
    )
      ''');
        },
      ));

  //getIt.registerSingleton<Database>(database);
  //NoteRepository repository = NoteRepositoryImpl(noteDbHelper);
  getIt.registerSingleton<NoteDbHelper>(NoteDbHelper(await getIt.getAsync()));
  getIt.registerSingleton<NoteRepository>(NoteRepositoryImpl(getIt.get()));
  getIt.registerSingleton<AddNoteUseCase>(AddNoteUseCase(getIt.get()));
  getIt.registerSingleton(DeleteNoteUseCase(getIt.get()));
  getIt.registerSingleton(GetNoteUseCase(getIt.get()));
  getIt.registerSingleton(GetNotesUseCase(getIt.get()));
  getIt.registerSingleton(UpdateNoteUseCase(getIt.get()));

  // NotesViewModel notesViewModel = NotesViewModel(useCases);
  getIt.registerFactory(
    () => NotesViewModel(
      UseCases(
        addNote: getIt.get(),
        deleteNote: getIt.get(),
        getNote: getIt.get(),
        getNotes: getIt.get(),
        updateNote: getIt.get(),
      ),
    ),
  );

  // AddEditNoteViewModel addEditNoteViewModel = AddEditNoteViewModel(repository);
  getIt.registerFactory(() => AddEditNoteViewModel(getIt.get()));
}
