// enum NoteOrder { title, date, color }
// enum OrderType { ascending, descending }

import 'package:clean_note_app_2/domain/util/order_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_order.freezed.dart';

@freezed
class NoteOrder with _$NoteOrder {
  const factory NoteOrder.title(OrderType orderType) = NoteOrderTitle;
  const factory NoteOrder.date(OrderType orderType) = NoteOrderDate;
  const factory NoteOrder.color(OrderType orderType) = NoteOrderColor;
}