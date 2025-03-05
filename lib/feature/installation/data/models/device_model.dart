class DeviceModel {
  final String id;
  final bool isActive;
  final String? activatedAt;
  final String? headUnitSn;

  DeviceModel({
    required this.id,
    required this.isActive,
    this.activatedAt,
    this.headUnitSn,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      isActive: json['is_active'],
      activatedAt: json['activated_at'],
      headUnitSn: json['head_unit_sn'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'head_unit_sn': id,
  };
}