import 'package:injectable/injectable.dart';
import '../entities/subject.dart';
import '../repositories/subject_repository.dart';

@lazySingleton
class GetSubjects {
  final SubjectRepository repository;

  GetSubjects(this.repository);

  Future<List<Subject>> call() async {
    return await repository.getSubjects();
  }
}