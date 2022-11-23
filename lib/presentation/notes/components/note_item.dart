import 'package:clean_note_app_2/domain/model/note.dart';
import 'package:clean_note_app_2/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  Function? onDeleteTap;

  // 반드시 Function 구현하려면 nullable(?)을 빼면 됨
  NoteItem({
    Key? key,
    required this.note,
    this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            // Stack으로 감싼 Container는 width 설정 필요
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(note.color),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // int timestamp 포맷 타입 변환 방법
                  DateFormat('yyyy-MM-dd').format(
                      DateTime.fromMillisecondsSinceEpoch(note.timestamp)),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5!.apply(
                        color: darkGray,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  note.content,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2!.apply(
                        color: darkGray,
                      ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  onDeleteTap?.call();
                  // Function onDeleteTap으로 nullable이 아니면, call() 생략 가능
                  // onDeleteTap;
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.black54,
                ),
              )),
        ],
      ),
    );
  }
}
