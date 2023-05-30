import 'package:ticket/model/role.dart';

class User {
  String id;
  String name;
  String email;
  Role role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        email = json['email'],
        name = json['name'],
        role = Role.fromJson(json['role']);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'role': role.toJson(),
      };
}
