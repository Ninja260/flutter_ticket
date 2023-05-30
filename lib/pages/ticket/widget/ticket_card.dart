import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticket/model/ticket.dart';
import 'package:ticket/pages/ticket/ticket_details_page.dart';
import 'package:ticket/utils/get_badge_color.dart';
import 'package:ticket/utils/has_permission.dart';
import 'package:ticket/view_model/user_vm.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  const TicketCard({
    Key? key,
    required this.ticket,
    required this.refreshIndicatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = context.read<UserVM>().user;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (hasPermission(user, 'TICKET_VIEW')) {
              Navigator.pushNamed(
                context,
                TicketDetailsPage.routeName,
                arguments: ticket,
              ).then((result) {
                if (result == 'refresh') {
                  refreshIndicatorKey.currentState?.show();
                }
              });
            }
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.topic,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  ticket.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    inherit: true,
                    height: 1.5,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
