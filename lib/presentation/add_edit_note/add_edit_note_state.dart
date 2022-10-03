import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_edit_note_state.freezed.dart';

part 'add_edit_note_state.g.dart';

@freezed
class AddEditNoteState with _$AddEditNoteState {
  const factory AddEditNoteState({
    Note? note,
    required int color,
  }) = _AddEditNoteState;

  factory AddEditNoteState.fromJson(Map<String, Object?> json) => _$AddEditNoteStateFromJson(json);
}