class LoginResponse {
  final String? id;
  final int? roleId;
  final String? roleName;
  final bool? isDefaultRole;
  final String? departmentId;
  final String? departmentName;
  final String? siteId;
  final String? siteName;
  final String? nik;
  final String? name;
  final String? email;
  final String? phone;
  final bool? isActive;
  final String? imageUrl;
  final String? unitId;
  final String? unitCode;
  final int? loginType;
  final int? loginStatus;
  final String? loginAt;

  LoginResponse({
    this.id,
    this.roleId,
    this.roleName,
    this.isDefaultRole,
    this.departmentId,
    this.departmentName,
    this.siteId,
    this.siteName,
    this.nik,
    this.name,
    this.email,
    this.phone,
    this.isActive,
    this.imageUrl,
    this.unitId,
    this.unitCode,
    this.loginType,
    this.loginStatus,
    this.loginAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return LoginResponse(
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
}