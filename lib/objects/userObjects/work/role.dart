/// Custom class to handle the role data
class RoleData{

  /// The role name
  final String roleName;

  RoleData({required this.roleName});

  factory RoleData.fromJson(Map<String, dynamic> json){
    return RoleData(
      roleName: json['role_name'],
    );
  }

}