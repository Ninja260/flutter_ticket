import 'package:ticket/model/user.dart';
import 'package:ticket/utils/http_util.dart';

const loginUrl = '/login';
const userInfoUrl = '/user/info';

class _UserApi {
  const _UserApi();

  Future<String> login({
    required String email,
    required String password,
  }) async {
    var res =
        await HttpUtil.post(loginUrl, {"email": email, "password": password});
    var token = res.body["data"]["token"];

    await HttpUtil.pref!.setString("token", token);
    return token;
  }

  Future<User> info() async {
    var res = await HttpUtil.get(userInfoUrl);
    var data = res.body["data"];

    return User.fromJson(data);
  }
}

const userApi = _UserApi();
