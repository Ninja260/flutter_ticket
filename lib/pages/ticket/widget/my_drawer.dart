import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket/pages/user/login.dart';
import 'package:ticket/utils/http_util.dart';
import 'package:ticket/view_model/ticket_list_page_vm.dart';
import 'package:ticket/view_model/user_vm.dart';

class MyDrawer extends StatelessWidget {
  final TextEditingController inputController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  const MyDrawer({
    Key? key,
    required this.inputController,
    required this.refreshIndicatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pageProvider = Provider.of<TicketListPageVM>(context);
    String type = pageProvider.type;

    return Drawer(
      child: SafeArea(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Consumer<UserVM>(
              builder: (context, vm, _) {
                var user = vm.user;
                if (user == null) return const SizedBox();

                return UserAccountsDrawerHeader(
                  accountName: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    user.email,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Concern Tickets'),
              selected: type == 'concern' ? true : false,
              leading: const Icon(
                Icons.email_rounded,
              ),
              onTap: () {
                if (type != 'concern') {
                  pageProvider.changeType('concern');
                  inputController.clear();
                  context.read<TicketListPageVM>().setHasText(false);
                  refreshIndicatorKey.currentState?.show();
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('All Tickets'),
              selected: type == 'all' ? true : false,
              leading: const Icon(
                Icons.inbox_rounded,
              ),
              onTap: () {
                if (type != 'all') {
                  pageProvider.changeType('all');
                  inputController.clear();
                  context.read<TicketListPageVM>().setHasText(false);
                  refreshIndicatorKey.currentState?.show();
                }
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(
                Icons.logout_rounded,
              ),
              onTap: () {
                HttpUtil.pref!.remove("token");
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginPage.routeName,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
