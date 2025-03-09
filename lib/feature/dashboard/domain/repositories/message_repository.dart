import '../entities/message.dart';

abstract class MessageRepository {
  Future<List<Message>> getMessages({
    required String page,
    required String limit,
    required String sort,
    required String equipmentId,
  });

  Future<Message> sendMessage({
    required String message,
    required String deviceType,
    required String equipmentId,
    required String categoryId,
  });
}