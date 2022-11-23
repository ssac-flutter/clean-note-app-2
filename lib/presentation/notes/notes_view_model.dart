import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:clean_note_app_2/domain/use_case/use_cases.dart';
import 'package:clean_note_app_2/domain/util/note_order.dart';
import 'package:clean_note_app_2/domain/util/order_type.dart';
import 'package:clean_note_app_2/presentation/notes/notes_event.dart';
import 'package:clean_note_app_2/presentation/notes/notes_state.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotesViewModel with ChangeNotifier {
  // use_case 사용 않고, repository로 mvvm 형태로 처리하는 경우
  // final NoteRepository repository;

  // use_case 사용하는 경우 위 repository는 use_case class에서 사용한다
  // final GetNotesUseCase getNotes;
  // final DeleteNoteUseCase deleteNote;
  // final AddNoteUseCase addNote;

  final UseCases useCases;

  // @Default([]) 지정한 경우 아래처럼
  // NotesState _state = NotesState();
  // required로 state 생성한 경우 초기값 넣어줘야 함
  NotesState _state = NotesState(
    notes: [],
    noteOrder: const NoteOrder.date(OrderType.descending()),
    isOrderSectionVisible: false,
    initialSelectedDate: DateTime.now().toLocal(),
  );

  NotesState get state => _state;

  Note? _recentlyDeletedNote;

  // 생성자에서 loadNotes()를 호출하여 화면 시작되면 뿌려준다.
  NotesViewModel(this.useCases) {
    _loadNotes();
  }

  // notes_screen에 필요한 3가지 이벤트 메서드를 만들 수 있지만, 휴먼 에러 방지를 위해
  // sealedClass로 notes_event를 만들어놓고 사용하는 것이 안전함.
  void onEvent(NotesEvent event) {
    event.when(
      loadNotes: _loadNotes,
      deleteNote: _deleteNote,
      restoreNote: _restoreNote,
      changeOrder: (NoteOrder noteOrder) {
        _state = state.copyWith(
          noteOrder: noteOrder,
        );

        _loadNotes();
      },
      toggleOrderSection: () {
        _state = state.copyWith(
          isOrderSectionVisible: !state.isOrderSectionVisible,
        );
        notifyListeners();
      },
    );
  }

  // const factory NotesState({
  // required List<Note> notes,}) = _NotesState;

  Future<void> _loadNotes() async {
    // getNotesUseCase.call()은 생략 가능
    // List<Note> notes = await getNotes();

    // notes_state에 noteOrder 추가한 후 인자로 받아옴옴
    List<Note> notes = await useCases.getNotes(state.noteOrder);

    List<Note> sortedNotes = [...notes];

    sortedNotes.sort((noteA, noteB) {
      return noteA.timestamp.compareTo(noteB.timestamp);
    });

    //List<Note> notes = await repository.getNotes();
    //notes.sort((a,b) => -a.timestamp.compareTo(b.timestamp));await repository.getNotes();

    final initialDate = DateTime.fromMillisecondsSinceEpoch(sortedNotes.first.timestamp);

    _state = state.copyWith(
      notes: notes,
      initialSelectedDate: initialDate,
    );
    notifyListeners();
  }

  Future<void> _deleteNote(Note note) async {
    // await repository.deleteNote(note); // useCase에서 repository 사용
    // await deleteNote(note);
    await useCases.deleteNote(note);
    // 삭제된 데이터를 resotoreNote()를 위해 따로 저장
    _recentlyDeletedNote = note;
    //삭제후 데이터 다시 읽어옴
    await _loadNotes();
  }

  // delete한 데이터를 _recentlyDeletedNote 변수에 따로 저장했다가 불러오면 됨
  Future<void> _restoreNote() async {
    if (_recentlyDeletedNote != null) {
      // await repository.insertNote(_recentlyDeletedNote!);
      // await addNote(_recentlyDeletedNote!);
      await useCases.addNote(_recentlyDeletedNote!);
      _recentlyDeletedNote = null;

      _loadNotes();
    }
  }

  DateTime _selectedDate = DateTime.now().toLocal();

  DateTime get selectedDate => _selectedDate;

  void dateChanged(date) {
    _selectedDate = date;
    // notifyListeners 잊지 말것!!
    notifyListeners();
  }
}
