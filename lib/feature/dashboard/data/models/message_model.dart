import 'package:injectable/injectable.dart';

import '../../domain/entities/message.dart';

@injectable
class MessageModel extends Message {
  MessageModel({
    required String id,
    required String equipmentId,
    required String senderNik,
    required bool isRead,
    required String message,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? senderName,
    required String deviceType,
    required String categoryId,
    required String equipmentCode,
    String? fleetId,
    required String equipmentSiteId,
    required String categoryName,
  }) : super(
    id: id,
    equipmentId: equipmentId,
    senderNik: senderNik,
    isRead: isRead,
    message: message,
    createdAt: createdAt,
    updatedAt: updatedAt,
    senderName: senderName,
    deviceType: deviceType,
    categoryId: categoryId,
    equipmentCode: equipmentCode,
    fleetId: fleetId,
    equipmentSiteId: equipmentSiteId,
    categoryName: categoryName,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      equipmentId: json['equipment_id'] as String,
      senderNik: json['sender_nik'] as String,
      isRead: json['is_read'] as bool,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      senderName: json['sender_name'] as String?,
      deviceType: json['device_type'] as String,
      categoryId: json['category_id'] as String,
      equipmentCode: json['equipment_code'] as String,
      fleetId: json['fleet_id'] as String?,
      equipmentSiteId: json['equipment_site_id'] as String,
      categoryName: json['category_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'equipment_id': equipmentId,
      'sender_nik': senderNik,
      'is_read': isRead,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sender_name': senderName,
      'device_type': deviceType,
      'category_id': categoryId,
      'equipment_code': equipmentCode,
      'fleet_id': fleetId,
      'equipment_site_id': equipmentSiteId,
      'category_name': categoryName,
    };
  }
}