import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_state.freezed.dart';

part 'notes_state.g.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
   required List<Note> notes,
   // @Default([]) List<Note> notes,
  }) = _NotesState;
  
  factory NotesState.fromJson(Map<String, Object?> json) => _$NotesStateFromJson(json);
}