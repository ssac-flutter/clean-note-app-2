import 'package:clean_note_app_2/di/provider_setup.dart';
import 'package:clean_note_app_2/domain/repository/note_repository.dart';
import 'package:clean_note_app_2/domain/use_case/add_note_use_case.dart';
import 'package:clean_note_app_2/domain/use_case/delete_note_use_case.dart';
import 'package:clean_note_app_2/domain/use_case/get_note_use_case.dart';
import 'package:clean_note_app_2/domain/use_case/get_notes_use_case.dart';
import 'package:clean_note_app_2/domain/use_case/update_note_use_case.dart';
import 'package:clean_note_app_2/domain/use_case/use_cases.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ViewModelModule {
  @injectable
  UseCases get notesViewModule => UseCases(
        addNote: getIt.get<AddNoteUseCase>(),
        deleteNote: getIt.get<DeleteNoteUseCase>(),
        getNote: getIt.get<GetNoteUseCase>(),
        getNotes: getIt.get<GetNotesUseCase>(),
        updateNote: getIt.get<UpdateNoteUseCase>(),
      );

  @injectable
  AddEditNoteViewModel get addEditNoteViewModel => AddEditNoteViewModel(
    getIt.get<NoteRepository>(),
  );
}
