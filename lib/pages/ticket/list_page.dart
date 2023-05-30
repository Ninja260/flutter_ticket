import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket/pages/ticket/form.dart';
import 'package:ticket/pages/ticket/widget/my_drawer.dart';
import 'package:ticket/pages/ticket/widget/search_box.dart';
import 'package:ticket/pages/ticket/widget/ticket_card.dart';
import 'package:ticket/model/ticket.dart';
import 'package:ticket/utils/handle_api_call_exception.dart';
import 'package:ticket/utils/has_permission.dart';
import 'package:ticket/view_model/ticket_list_page_vm.dart';
import 'package:ticket/view_model/user_vm.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({
    super.key,
  });

  static const routeName = '/ticket_list';

  @override
  State<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => _refreshIndicatorKey.currentState?.show(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshTicket(String search) async {
    try {
      await Provider.of<TicketListPageVM>(context, listen: false)
          .refreshList(search);
    } catch (err) {
      handleApiCallException(context: context, e: err);
    }
  }

  @override
  Widget build(BuildContext context) {
    var pageProvider = Provider.of<TicketListPageVM>(context);
    String type = pageProvider.type;
    String title = type == 'concern' ? 'Concern Tickets' : 'All Tickets';
    List<Ticket> ticketList = pageProvider.ticketList;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onTapDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onVerticalDragDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        drawer: MyDrawer(
          inputController: _searchController,
          refreshIndicatorKey: _refreshIndicatorKey,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Material(
              elevation: 4,
              child: SearchBox(
                inputControl: _searchController,
                focusNode: _focusNode,
                refreshIndicatorKey: _refreshIndicatorKey,
                scaffoldKey: _key,
                hintText: 'Search Ticket',
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  await _refreshTicket(_searchController.text);
                },
                child: Builder(builder: (context) {
                  if (ticketList.isEmpty) {
                    return _EmptyResult(title: title);
                  }

                  return ListView.builder(
                    restorationId: 'ticketListView',
                    padding: const EdgeInsets.only(bottom: 80.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: ticketList.length + 1,
                    itemBuilder: (BuildContext context, index) {
                      if (index == 0) {
                        return _Title(title: title);
                      }

                      var ticket = ticketList[index - 1];

                      return TicketCard(
                        key: Key(ticket.id!),
                        ticket: ticket,
                        refreshIndicatorKey: _refreshIndicatorKey,
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
        floatingActionButton: _getFloatingActionButton(),
      ),
    );
  }

  FloatingActionButton? _getFloatingActionButton() {
    var user = context.read<UserVM>().user;
    if (hasPermission(user, 'TICKET_CREATE')) {
      return FloatingActionButton(
        onPressed: () {
          // _refreshIndicatorKey.currentState?.show();
          _focusNode.unfocus();
          Navigator.pushNamed(
            context,
            TicketFormPage.routeName,
            arguments: const TicketFormPayload(
              title: 'Issue Ticket',
            ),
          ).then((result) {
            if (result == 'refresh') {
              _refreshIndicatorKey.currentState?.show();
            }
          });
        },
        child: const Icon(Icons.add),
      );
    }

    return null;
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.blue),
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  final String title;
  const _EmptyResult({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height - 160;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Title(title: title),
          SizedBox(
            height: height,
            child: const Center(
              child: Text('No result to show.'),
            ),
          ),
        ],
      ),
    );
  }
}
