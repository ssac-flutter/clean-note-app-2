import 'dart:async';

import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:clean_note_app_2/domain/repository/note_repository.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_ui_event.dart';
import 'package:clean_note_app_2/ui/colors.dart';
import 'package:flutter/material.dart';

class AddEditNoteViewModel with ChangeNotifier {
  // mvvm 방식, use_case 사용안하는 경우
  final NoteRepository repository;

  int _color = roseBud.value;

  int get color => _color;

  // 이벤트 발생할 때마다 _eventController에 넣어서 ui initState()에 전달할때
  // 여러번 listen할 수 있게 하는 broadcast()와 screen에서 한번만 불러오게 하는 Subscription 처리한다
  final _eventController = StreamController<AddEditNoteUiEvent>.broadcast();

  Stream<AddEditNoteUiEvent> get eventSteam => _eventController.stream;

  AddEditNoteViewModel(this.repository);

  void onEvent(AddEditNoteEvent event) {
    event.when(
      changeColor: _changeColor,
      saveNote: _saveNote,
    );
  }

  Future<void> _changeColor(int color) async {
    _color = color;
    notifyListeners();
  }

  Future<void> _saveNote(int? id, String title, String content) async {
    if (title.isEmpty || content.isEmpty) {
      _eventController.add(
        const AddEditNoteUiEvent.showSnackBar('제목이나 내용이 비어있습니다'),);
      return;
    }
    if (id == null) {
      await repository.insertNote(
        Note(
          title: title,
          content: content,
          color: _color,
          timestamp: DateTime
              .now()
              .millisecondsSinceEpoch,
        ),
      );
    } else {
      // updateNote 경우 id를 알고 있다.
      await repository.updateNote(
        Note(
          id: id,
          title: title,
          content: content,
          color: _color,
          timestamp: DateTime
              .now()
              .millisecondsSinceEpoch,
        ),
      );
    }
    //_saveNote 처리할 때마다, screen의 initState에 넣어준다.
    _eventController.add(const AddEditNoteUiEvent.saveNote());
  }
}
