import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:clean_note_app_2/domain/util/note_order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_state.freezed.dart';

// freezed 안에 NoteOrder freezed 실행하며 나는 에러 제거
// part 'notes_state.g.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    // @Default([]) List<Note> notes,
    required List<Note> notes,
    required NoteOrder noteOrder,
    required bool isOrderSectionVisible,
    required DateTime initialSelectedDate,
  }) = _NotesState;

// factory NotesState.fromJson(Map<String, Object?> json) => _$NotesStateFromJson(json);
}
