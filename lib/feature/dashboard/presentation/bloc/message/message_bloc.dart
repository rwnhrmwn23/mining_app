import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/get_messages.dart';
import 'message_event.dart';
import 'message_state.dart';

@lazySingleton
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessages getMessages;

  MessageBloc(this.getMessages) : super(MessageInitial()) {
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
  }
}