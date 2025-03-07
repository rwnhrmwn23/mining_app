
import '../../domain/entities/login_responses.dart';

class LoginResponseModel extends LoginResponse {
  LoginResponseModel({
    String? id,
    int? roleId,
    String? roleName,
    bool? isDefaultRole,
    String? departmentId,
    String? departmentName,
    String? siteId,
    String? siteName,
    String? nik,
    String? name,
    String? email,
    String? phone,
    bool? isActive,
    String? imageUrl,
    String? unitId,
    String? unitCode,
    int? loginType,
    int? loginStatus,
    String? loginAt,
  }) : super(
    id: id,
    roleId: roleId,
    roleName: roleName,
    isDefaultRole: isDefaultRole,
    departmentId: departmentId,
    departmentName: departmentName,
    siteId: siteId,
    siteName: siteName,
    nik: nik,
    name: name,
    email: email,
    phone: phone,
    isActive: isActive,
    imageUrl: imageUrl,
    unitId: unitId,
    unitCode: unitCode,
    loginType: loginType,
    loginStatus: loginStatus,
    loginAt: loginAt,
  );

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return LoginResponseModel(
      id: data['id'] as String?,
      roleId: data['role_id'] as int?,
      roleName: data['role_name'] as String?,
      isDefaultRole: data['is_default_role'] as bool?,
      departmentId: data['department_id'] as String?,
      departmentName: data['department_name'] as String?,
      siteId: data['site_id'] as String?,
      siteName: data['site_name'] as String?,
      nik: data['nik'] as String?,
      name: data['name'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      isActive: data['is_active'] as bool?,
      imageUrl: data['image_url'] as String?,
      unitId: data['unit_id'] as String?,
      unitCode: data['unit_code'] as String?,
      loginType: data['login_type'] as int?,
      loginStatus: data['login_status'] as int?,
      loginAt: data['login_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'id': id,
        'role_id': roleId,
        'role_name': roleName,
        'is_default_role': isDefaultRole,
        'department_id': departmentId,
        'department_name': departmentName,
        'site_id': siteId,
        'site_name': siteName,
        'nik': nik,
        'name': name,
        'email': email,
        'phone': phone,
        'is_active': isActive,
        'image_url': imageUrl,
        'unit_id': unitId,
        'unit_code': unitCode,
        'login_type': loginType,
        'login_status': loginStatus,
        'login_at': loginAt,
      },
    };
  }
}