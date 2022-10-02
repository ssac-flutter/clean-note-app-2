import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_edit_note_event.freezed.dart';

@freezed
class AddEditNoteEvent with _$AddEditNoteEvent {
  const factory AddEditNoteEvent.changeColor(int color) = ChangeColor;
  const factory AddEditNoteEvent.saveNote(int? id, String title, String content, int color, int timestamp) = SaveNote;
}