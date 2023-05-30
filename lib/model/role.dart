class Role {
  String id;
  String name;
  List<String> permissions;

  Role({
    required this.id,
    required this.name,
    required this.permissions,
  });

  Role.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        permissions = List<String>.from(json['permissions']);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'permissions': permissions,
      };
}
