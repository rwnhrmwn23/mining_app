import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_subjects.dart';
import 'subject_event.dart';
import 'subject_state.dart';

@lazySingleton
class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final GetSubjects getSubjects;

  SubjectBloc(this.getSubjects) : super(SubjectInitial()) {
    on<FetchSubjects>((event, emit) async {
      emit(SubjectLoading());
      try {
        final subjects = await getSubjects();
        emit(SubjectLoaded(subjects));
      } catch (e) {
        emit(SubjectError(e.toString()));
      }
    });
  }
}