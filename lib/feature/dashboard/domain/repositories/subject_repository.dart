import '../entities/subject.dart';

abstract class SubjectRepository {
  Future<List<Subject>> getSubjects();
}