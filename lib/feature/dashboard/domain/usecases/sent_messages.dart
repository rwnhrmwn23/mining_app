import 'package:injectable/injectable.dart';
import '../entities/message.dart';
import '../repositories/message_repository.dart';

@lazySingleton
class SentMessage {
  final MessageRepository repository;

  SentMessage(this.repository);

  Future<Message> call({
    required String message,
    required String deviceType,
    required String equipmentId,
    required String categoryId,
  }) async {
    return await repository.sendMessage(
      message: message,
      deviceType: deviceType,
      equipmentId: equipmentId,
      categoryId: categoryId,
    );
  }
}