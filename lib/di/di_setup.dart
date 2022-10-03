import 'package:clean_note_app_2/data/data_source/note_db_helper.dart';
import 'package:clean_note_app_2/data/repository/note_repository_impl.dart';
import 'package:clean_note_app_2/di/provider_setup.dart';
import 'package:clean_note_app_2/domain/repository/note_repository.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RepositoryModule {
  @singleton
  NoteRepository get noteRepository => NoteRepositoryImpl(
        getIt.get<NoteDbHelper>(),
      );
}
