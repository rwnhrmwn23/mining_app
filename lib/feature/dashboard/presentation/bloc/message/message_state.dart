import 'package:equatable/equatable.dart';

import '../../../domain/entities/message.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<Message> messages;

  const MessageLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessageError extends MessageState {
  final String message;

  const MessageError(this.message);

  @override
  List<Object?> get props => [message];
}

class SentMessageLoading extends MessageState {}

class SentMessageLoaded extends MessageState {
  final Message message;

  const SentMessageLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class SentMessageError extends MessageState {
  final String message;

  const SentMessageError(this.message);

  @override
  List<Object?> get props => [message];
}