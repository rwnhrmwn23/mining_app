import 'package:injectable/injectable.dart';
import 'package:mining_app/feature/dashboard/data/datasources/remote_subject_datasource.dart';
import '../../domain/entities/subject.dart';
import '../../domain/repositories/subject_repository.dart';

@LazySingleton(as: SubjectRepository)
class SubjectRepositoryImpl implements SubjectRepository {
  final RemoteSubjectDataSource remoteDataSource;

  SubjectRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Subject>> getSubjects() async {
    try {
      final subjects = await remoteDataSource.getTemplateMessage();
      return subjects;
    } catch (e) {
      throw Exception('Failed to fetch subjects: $e');
    }
  }
}