import 'dart:async';

import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:clean_note_app_2/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:clean_note_app_2/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  // Note가 비어있을 수도 있으니, 널러블로 처리
  final Note? note;

  const AddEditNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  // eventStream이 계속 listen하는 것을 막아주는 변수
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    // navPush로 넘어온 note 값을 받아주는 기능, null check 않으면 에러 발생
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }

    Future.microtask(() {
      final viewModel = context.read<AddEditNoteViewModel>();
      // viewModel을 read로 불러올 때는 Stream으로 작성
      _streamSubscription = viewModel.eventSteam.listen((event) {
        event.when(saveNote: () {
          // true: saveNote로 이벤트 처리했음을 전달
          Navigator.pop(context, true);
          // notes_screen에서 isSaved 삼항연산으로 구분 처리
        }, showSnackBar: (String message) {
          final snackBar = SnackBar(content: Text(message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      });
    });
  }

  @override
  void dispose() {
    // _streamSubscription이 있다면 cancel() 처리 후
    // 다음번에 들어올때 다시 listen한다
    _streamSubscription?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  final List<Color> noteColors = [
    roseBud,
    primrose,
    wisteria,
    skyBlue,
    illusion,
  ];

  // final Color _color = roseBud;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddEditNoteViewModel>();
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
        color: Color(viewModel.color),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: noteColors
                  .map(
                    (color) => InkWell(
                      onTap: () {
                        viewModel.onEvent(
                          AddEditNoteEvent.changeColor(color.value),
                        );
                      },
                      // Widget _buildBackgroundColor({required Color color, required bool selected})
                      child: _buildBackgroundColor(
                        color: color,
                        selected: viewModel.color == color.value,
                      ),
                    ),
                  )
                  .toList(),
            ),
            TextField(
              controller: _titleController,
              maxLines: 1,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: darkGray,
                  ),
              decoration: const InputDecoration(
                hintText: '제목을 입력하세요',
                hintStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: _contentController,
              maxLines: null,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: darkGray,
                  ),
              decoration: const InputDecoration(
                hintText: '내용을 입력하세요',
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.onEvent(AddEditNoteEvent.saveNote(
            widget.note == null ? null : widget.note!.id,
            _titleController.text,
            _contentController.text,
          ));
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildBackgroundColor({required Color color, required bool selected}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ),
        ],
        border: selected
            ? Border.all(
                color: Colors.black,
                width: 2.0,
              )
            : null,
      ),
    );
  }
}
