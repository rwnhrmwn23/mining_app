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

class SendingMessage extends MessageEvent {
  final String message;
  final String deviceType;
  final String equipmentId;
  final String categoryId;

  const SendingMessage({
    required this.message,
    required this.deviceType,
    required this.equipmentId,
    required this.categoryId,
  });

  @override
  List<Object> get props => [message, deviceType, equipmentId, categoryId];
}