import 'package:injectable/injectable.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/remote_message_datasource.dart';

@LazySingleton(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  final RemoteMessageDataSource dataSource;

  MessageRepositoryImpl(this.dataSource);

  @override
  Future<List<Message>> getMessages({
    required String page,
    required String limit,
    required String sort,
    required String equipmentId,
  }) async {
    final messages = await dataSource.getMessages(
      page: page,
      limit: limit,
      sort: sort,
      equipmentId: equipmentId,
    );
    return messages.map((model) => model).toList();
  }

  @override
  Future<Message> sendMessage({
    required String message,
      required String deviceType,
      required String equipmentId,
      required String categoryId
  }) async  {
    final sendMessage = await dataSource.sendMessage(
      message: message,
      deviceType: deviceType,
      equipmentId: equipmentId,
      categoryId: categoryId,
    );
    return sendMessage;
  }
}
