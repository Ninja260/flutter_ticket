import 'package:ticket/model/user.dart';

bool hasPermission(User? user, String permission) {
  if (user == null) return false;
  var permissions = user.role.permissions;
  if (permissions.contains(permission)) {
    return true;
  }

  return false;
}
