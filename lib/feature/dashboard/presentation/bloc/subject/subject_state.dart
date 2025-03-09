import 'package:equatable/equatable.dart';
import '../../../domain/entities/subject.dart';

abstract class SubjectState extends Equatable {
  const SubjectState();

  @override
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<Subject> subjects;

  const SubjectLoaded(this.subjects);

  @override
  List<Object?> get props => [subjects];
}

class SubjectError extends SubjectState {
  final String message;

  const SubjectError(this.message);

  @override
  List<Object?> get props => [message];
}