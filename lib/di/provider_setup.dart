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

// 탑레벨에서 db 먼저 작성 후 main에서 getProvider()를 호출해서 사용한다
// Future<List<SingleChildWidget>> getProviders() async {

// GetIt 의존성 주입
final getIt = GetIt.I;

Future<void> setupDi() async {
  Database database = await openDatabase(
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
  );

  // NoteDbHelper noteDbHelper = NoteDbHelper(database);
  getIt.registerSingleton<Database>(database);

  //NoteRepository repository = NoteRepositoryImpl(noteDbHelper);
  getIt.registerSingleton<NoteDbHelper>(NoteDbHelper((getIt.get<Database>())));
  getIt.registerSingleton<NoteRepository>(
      NoteRepositoryImpl(getIt.get<NoteDbHelper>()));

  // UseCases useCases = UseCases(
  //   addNote: AddNoteUseCase(repository),
  //   deleteNote: DeleteNoteUseCase(repository),
  //   getNote: GetNoteUseCase(repository),
  //   getNotes: GetNotesUseCase(repository),
  //   updateNote: UpdateNoteUseCase(repository),
  // );
  getIt.registerSingleton<AddNoteUseCase>(
      AddNoteUseCase(getIt.get<NoteRepository>()));
  getIt.registerSingleton<DeleteNoteUseCase>(
      DeleteNoteUseCase(getIt.get<NoteRepository>()));
  getIt.registerSingleton<GetNoteUseCase>(
      GetNoteUseCase(getIt.get<NoteRepository>()));
  getIt.registerSingleton<GetNotesUseCase>(
      GetNotesUseCase(getIt.get<NoteRepository>()));
  getIt.registerSingleton<UpdateNoteUseCase>(
      UpdateNoteUseCase(getIt.get<NoteRepository>()));

  // NotesViewModel notesViewModel = NotesViewModel(useCases);
  getIt.registerFactory(() => NotesViewModel(UseCases(
        addNote: getIt.get<AddNoteUseCase>(),
        deleteNote: getIt.get<DeleteNoteUseCase>(),
        getNote: getIt.get<GetNoteUseCase>(),
        getNotes: getIt.get<GetNotesUseCase>(),
        updateNote: getIt.get<UpdateNoteUseCase>(),
      )));

  // AddEditNoteViewModel addEditNoteViewModel = AddEditNoteViewModel(repository);
  getIt
      .registerFactory(() => AddEditNoteViewModel(getIt.get<NoteRepository>()));

  // return [
  //   ChangeNotifierProvider(create: (_) => notesViewModel),
  //   // ChangeNotifierProvider(create: (_) => addEditNoteViewModel)
  //   Provider(create: (_) => repository),
  // ];
}
