import '../../domain/entities/subject.dart';

class SubjectModel extends Subject {
  SubjectModel({
    required String id,
    required String name,
    required String categoryId,
    required String createdAt,
    required String updatedAt,
    required String categoryName,
    required bool isForOperator,
    required bool isForDispatch,
    required bool isActive,
    required bool isNotifScheduler,
    required String templateMessageOperator,
    required String templateMessageDispatch,
  }) : super(
    id: id,
    name: name,
    categoryId: categoryId,
    createdAt: createdAt,
    updatedAt: updatedAt,
    categoryName: categoryName,
    isForOperator: isForOperator,
    isForDispatch: isForDispatch,
    isActive: isActive,
    isNotifScheduler: isNotifScheduler,
    templateMessageOperator: templateMessageOperator,
    templateMessageDispatch: templateMessageDispatch,
  );

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      categoryId: json['category_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      categoryName: json['category_name'] ?? '',
      isForOperator: json['is_for_operator'] ?? false,
      isForDispatch: json['is_for_dispatch'] ?? false,
      isActive: json['is_active'] ?? false,
      isNotifScheduler: json['is_notif_scheduler'] ?? false,
      templateMessageOperator: json['template_message_operator'] ?? '',
      templateMessageDispatch: json['template_message_dispatch'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category_name': categoryName,
      'is_for_operator': isForOperator,
      'is_for_dispatch': isForDispatch,
      'is_active': isActive,
      'is_notif_scheduler': isNotifScheduler,
      'template_message_operator': templateMessageOperator,
      'template_message_dispatch': templateMessageDispatch,
    };
  }
}