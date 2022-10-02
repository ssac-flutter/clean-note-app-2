import 'package:clean_note_app_2/domain/repository/note_repository.dart';
import 'package:clean_note_app_2/presentation/notes/notes_event.dart';
import 'package:clean_note_app_2/presentation/notes/notes_state.dart';
import 'package:flutter/material.dart';

import '../../domain/model/note.dart';

class NotesViewModel with ChangeNotifier {
  // use_case 사용 않고, repository로만 mvvm 형태로 처리하는 경우
  final NoteRepository repository;

  // @Default([]) 지정한 경우
  // NotesState _state = NotesState();
  // required로 state 생성한 경우 초기값 넣어줘야 함
  NotesState _state = NotesState(notes: []);

  NotesState get state => _state;

  Note? _recentlyDeletedNote;

  NotesViewModel(this.repository);

  // notes_screen에 필요한 3가지 이벤트 메서드를 만들 수 있지만, 휴먼 에러 방지를 위해
  // sealedClass로 notes_event를 만들어놓고 사용하는 것이 안전함.
  void onEvent(NotesEvent event) {
    event.when(
      loadNotes: _loadNotes,
      deleteNote: _delteNote,
      restoreNote: _resotreNote,
    );
  }

  // const factory NotesState({
  // required List<Note> notes,}) = _NotesState;
  Future<void> _loadNotes() async {
    List<Note> notes = await repository.getNotes();
    _state = state.copyWith(
      notes: notes,
    );
    notifyListeners();
  }

  Future<void> _delteNote(Note note) async {
    await repository.deleteNote(note);
    // 삭제된 데이터를 resotoreNote()를 위해 따로 저장
    _recentlyDeletedNote = note;
    //삭제후 데이터 다시 읽어옴
    await _loadNotes();
  }

  // delete한 데이터를 _recentlyDeletedNote 변수에 따로 저장했다가 불러오면 됨
  Future<void> _resotreNote() async {
    if (_recentlyDeletedNote != null) {
      await repository.insertNote(_recentlyDeletedNote!);
      _recentlyDeletedNote = null;

      _loadNotes();
    }
  }
}
