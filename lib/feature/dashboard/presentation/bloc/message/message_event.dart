import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class FetchMessages extends MessageEvent {
  final String page;
  final String limit;
  final String sort;
  final String equipmentId;

  const FetchMessages({
    required this.page,
    required this.limit,
    required this.sort,
    required this.equipmentId,
  });

  @override
  List<Object> get props => [page, limit, sort, equipmentId];
}