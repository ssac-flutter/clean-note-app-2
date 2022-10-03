import 'dart:math';

import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:clean_note_app_2/domain/repository/note_repository.dart';
import 'package:clean_note_app_2/domain/use_case/get_notes_use_case.dart';
import 'package:clean_note_app_2/domain/util/note_order.dart';
import 'package:clean_note_app_2/domain/util/order_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_notes_use_case_test.mocks.dart';

// mockito를 이용하여, 가짜 NoteRepository(MockitoRepository)로
// GetNotesUseCase 테스트 , build_runner 해야 함

@GenerateMocks([NoteRepository])
void main () {
  test('정렬 기능이 잘 동작해야 함', () async {
    // MockRepository는 기능이 없기에, mockito가 제공하는 when함수로 정의를 해줘야함
    final repository = MockNoteRepository();
    final getNotes = GetNotesUseCase(repository);
    // fakeDate로 동작 정의하기
    when(repository.getNotes()).thenAnswer((_) async => [
      const Note(title: 'title', content: 'content', color: 0, timestamp: 1),
      const Note(title: 'title2', content: 'content2', color: 1, timestamp: 2),
    ]);

    List<Note> result = await getNotes(const NoteOrder.date(OrderType.descending()));
    // type check : isA<T>();
    expect(result, isA<List<Note>>());
    expect(result.first.timestamp, 2);
    // 메서드 수행 결과 검증
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.date(OrderType.ascending()));
    expect(result.first.timestamp, 1);
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.title(OrderType.descending()));
    expect(result.first.title, 'title2');
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.title(OrderType.ascending()));
    expect(result.first.title, 'title');
    verify(repository.getNotes());

    verifyNoMoreInteractions(repository);
  });
}