import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_edit_note_ui_event.freezed.dart';

// viewModel event를 screen에 알려주기 위한 이벤트 처리
@freezed
class AddEditNoteUiEvent with _$AddEditNoteUiEvent {
  // add_screen에서 initeState()로 처리
  const factory AddEditNoteUiEvent.saveNote() = SaveNote;
}