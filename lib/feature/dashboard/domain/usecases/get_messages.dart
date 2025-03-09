import 'package:injectable/injectable.dart';
import '../entities/message.dart';
import '../repositories/message_repository.dart';

@lazySingleton
class GetMessages {
  final MessageRepository repository;

  GetMessages(this.repository);

  Future<List<Message>> call({
    required String page,
    required String limit,
    required String sort,
    required String equipmentId,
  }) async {
    return await repository.getMessages(
      page: page,
      limit: limit,
      sort: sort,
      equipmentId: equipmentId,
    );
  }
}