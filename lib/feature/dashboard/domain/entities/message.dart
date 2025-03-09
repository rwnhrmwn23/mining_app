import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String equipmentId;
  final String senderNik;
  final bool isRead;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? senderName;
  final String deviceType;
  final String categoryId;
  final String equipmentCode;
  final String? fleetId;
  final String equipmentSiteId;
  final String categoryName;

  const Message({
    required this.id,
    required this.equipmentId,
    required this.senderNik,
    required this.isRead,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    this.senderName,
    required this.deviceType,
    required this.categoryId,
    required this.equipmentCode,
    this.fleetId,
    required this.equipmentSiteId,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [
    id,
    equipmentId,
    senderNik,
    isRead,
    message,
    createdAt,
    updatedAt,
    senderName,
    deviceType,
    categoryId,
    equipmentCode,
    fleetId,
    equipmentSiteId,
    categoryName,
  ];
}