import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String createdAt;
  final String updatedAt;
  final String categoryName;
  final bool isForOperator;
  final bool isForDispatch;
  final bool isActive;
  final bool isNotifScheduler;
  final String templateMessageOperator;
  final String templateMessageDispatch;

  const Subject({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryName,
    required this.isForOperator,
    required this.isForDispatch,
    required this.isActive,
    required this.isNotifScheduler,
    required this.templateMessageOperator,
    required this.templateMessageDispatch,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    categoryId,
    createdAt,
    updatedAt,
    categoryName,
    isForOperator,
    isForDispatch,
    isActive,
    isNotifScheduler,
    templateMessageOperator,
    templateMessageDispatch,
  ];
}