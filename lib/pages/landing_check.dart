import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket/api/user.dart';
import 'package:ticket/pages/user/login.dart';
import 'package:ticket/pages/ticket/list_page.dart';
import 'package:ticket/view_model/user_vm.dart';

class LandingCheckPage extends StatefulWidget {
  const LandingCheckPage({Key? key}) : super(key: key);

  @override
  State<LandingCheckPage> createState() => _LandingCheckPageState();
}

class _LandingCheckPageState extends State<LandingCheckPage> {
  @override
  void initState() {
    // check share preference
    var userProvider = Provider.of<UserVM>(context, listen: false);
    SharedPreferences.getInstance().then((instance) async {
      String? token = instance.getString('token');
      if (token == null) {
        goToLoginPage();
        return;
      }
      try {
        var user = await userApi.info();
        userProvider.setUserInfo(user);
        goToTicketListPage();
      } catch (e) {
        goToLoginPage();
      }
    });
    super.initState();
  }

  void goToLoginPage() {
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }

  void goToTicketListPage() {
    Navigator.pushReplacementNamed(context, TicketListPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
