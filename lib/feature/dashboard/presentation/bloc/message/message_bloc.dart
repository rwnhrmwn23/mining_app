import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/get_messages.dart';
import '../../../domain/usecases/sent_messages.dart';
import 'message_event.dart';
import 'message_state.dart';
import '../../../domain/entities/message.dart';

@lazySingleton
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessages getMessages;
  final SentMessage sentMessages;

  MessageBloc(this.getMessages, this.sentMessages) : super(MessageInitial()) {

    on<FetchMessages>((event, emit) async {
      emit(MessageLoading());
      try {
        final messages = await getMessages(
          page: event.page,
          limit: event.limit,
          sort: event.sort,
          equipmentId: event.equipmentId,
        );
        emit(MessageLoaded(messages));
      } catch (e) {
        emit(MessageError(e.toString()));
      }
    });

    on<SendingMessage>((event, emit) async {
      emit(SentMessageLoading());
      try {
        final messages = await sentMessages(
          message: event.message,
          deviceType: event.deviceType,
          equipmentId: event.equipmentId,
          categoryId: event.categoryId,
        );
        emit(SentMessageLoaded(messages));

        // After sending message, fetch updated messages
        await Future.delayed(const Duration(milliseconds: 500));
        add(FetchMessages(
          page: '1',
          limit: '100',
          sort: 'created_at,asc',
          equipmentId: event.equipmentId,
        ));
      } catch (e) {
        emit(SentMessageError(e.toString()));
      }
    });

    on<UpdateMessages>((event, emit) async {
      if (state is MessageLoaded) {
        final currentMessages = (state as MessageLoaded).messages;
        final updatedMessages = List<Message>.from(currentMessages)..addAll(event.messages);
        emit(MessageLoaded(updatedMessages));
      } else {
        emit(MessageLoaded(event.messages));
      }
    });
  }
}
