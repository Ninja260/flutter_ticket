import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticket/api/ticket.dart';
import 'package:ticket/model/log.dart';
import 'package:ticket/model/ticket.dart';
import 'package:ticket/pages/ticket/form.dart';
import 'package:ticket/utils/get_badge_color.dart';
import 'package:ticket/utils/handle_api_call_exception.dart';
import 'package:ticket/utils/has_permission.dart';
import 'package:ticket/utils/show_loading_dialog.dart';
import 'package:ticket/utils/show_success_dialog.dart';
import 'package:ticket/view_model/user_vm.dart';

class TicketDetailsCard extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailsCard({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                ticket.topic,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                ticket.description,
                softWrap: true,
                style: const TextStyle(
                  inherit: true,
                  height: 1.5,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: getBadgeColor(ticket.status),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ticket.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.date_range,
                        color: Colors.black54,
                        size: 12.0,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd')
                            .format(ticket.createdTime.toLocal()),
                        style: const TextStyle(
                          inherit: true,
                          color: Colors.black54,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _EditButton(ticket: ticket),
                  _ActionButton(
                    text: 'INQUIRE',
                    color: Colors.red,
                    permission: 'TICKET_INQUIRE',
                    ticket: ticket,
                  ),
                  _ActionButton(
                    text: 'APPROVE',
                    permission: 'TICKET_APPROVE',
                    ticket: ticket,
                  ),
                ],
              ),
              const Divider(),
              _Logs(ticketId: ticket.id!),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String text;
  final Color? color;
  final String permission;
  final Ticket ticket;
  const _ActionButton({
    Key? key,
    required this.text,
    this.color,
    required this.permission,
    required this.ticket,
  }) : super(key: key);

  @override
  State<_ActionButton> createState() => __ActionButtonState();
}

class __ActionButtonState extends State<_ActionButton> {
  @override
  Widget build(BuildContext context) {
    var user = context.read<UserVM>().user!;
    if (widget.ticket.status != 'REVIEW') {
      return const SizedBox();
    }
    if (!hasPermission(user, widget.permission)) return const SizedBox();
    if (widget.ticket.approverIds.contains(user.id)) return const SizedBox();
    if (user.role.id != widget.ticket.nextApproverRoleId) {
      return const SizedBox();
    }

    return TextButton(
      onPressed: _handleClick,
      child: Text(
        widget.text.toUpperCase(),
        style: TextStyle(
          inherit: true,
          color: widget.color,
        ),
      ),
    );
  }

  _handleClick() {
    switch (widget.permission) {
      case 'TICKET_APPROVE':
        _approveTicket();
        break;
      case 'TICKET_INQUIRE':
        _inquireTicket();
        break;
    }
  }

  _approveTicket() {
    showLoadingDialog(context: context, text: "Approve ticket...");
    ticketApi.approve(id: widget.ticket.id!).then((message) {
      Navigator.pop(context); // pop loading dialog
      showSuccessDialog(
        context: context,
        title: "Success",
        content: message,
      ).then(
        (_) => Navigator.pop(context, 'refresh'),
      );
    }).catchError((err) {
      Navigator.pop(context); // pop loading dialog
      handleApiCallException(context: context, e: err);
    });
  }

  _inquireTicket() {
    showLoadingDialog(context: context, text: "Inquire ticket...");
    ticketApi.inquire(id: widget.ticket.id!).then((message) {
      Navigator.pop(context); // pop loading dialog
      showSuccessDialog(
        context: context,
        title: "Success",
        content: message,
      ).then(
        (_) => Navigator.pop(context, 'refresh'),
      );
    }).catchError((err) {
      Navigator.pop(context); // pop loading dialog
      handleApiCallException(context: context, e: err);
    });
  }
}

class _EditButton extends StatefulWidget {
  final String text = 'EDIT';
  final String permission = 'TICKET_EDIT';
  final Ticket ticket;

  const _EditButton({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  State<_EditButton> createState() => __EditButtonState();
}

class __EditButtonState extends State<_EditButton> {
  @override
  Widget build(BuildContext context) {
    var user = context.read<UserVM>().user;
    if (widget.ticket.status != 'INQUIRY') {
      return const SizedBox();
    }
    if (!hasPermission(user, widget.permission)) return const SizedBox();
    if (widget.ticket.issuerId != user!.id) return const SizedBox();

    return TextButton(
      onPressed: _handleClick,
      child: Text(
        widget.text.toUpperCase(),
      ),
    );
  }

  _handleClick() {
    Navigator.pushNamed(context, TicketFormPage.routeName,
        arguments: TicketFormPayload(
          title: "Edit Ticket",
          ticket: widget.ticket,
        )).then(
      (result) {
        if (result == 'refresh') {
          Navigator.pop(context, 'refresh');
        }
      },
    );
  }
}

class _Logs extends StatefulWidget {
  final String ticketId;

  const _Logs({
    Key? key,
    required this.ticketId,
  }) : super(key: key);

  @override
  __LogsState createState() => __LogsState();
}

class __LogsState extends State<_Logs> {
  bool loading = true;
  List<Log> logs = [];

  @override
  void initState() {
    ticketApi.getLogs(widget.ticketId).then((result) {
      setState(() {
        logs = result;
        loading = false;
      });
    }).catchError((err) {
      handleApiCallException(context: context, e: err);
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: 16.0,
          ),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (logs.isEmpty) {
      return const Center(
        child: Text('There is no log recorded.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Logs",
          style: textTheme.titleSmall,
        ),
        Table(
          border: const TableBorder(
            horizontalInside: BorderSide(
              width: 1,
              color: Color(0xFFEEEEEE),
              style: BorderStyle.solid,
            ),
          ),
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(1.0),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: <TableRow>[
            for (var log in logs)
              TableRow(
                children: <TableCell>[
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              DateFormat('yyy-MM-dd')
                                  .format(log.time.toLocal()),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              DateFormat('h:m a').format(log.time.toLocal()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        log.text,
                      ),
                    ),
                  )
                ],
              ),
          ],
        ),
      ],
    );
  }
}
