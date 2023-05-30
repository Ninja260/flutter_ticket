import 'package:flutter/material.dart';
import 'package:ticket/model/ticket.dart';
import 'package:ticket/pages/ticket/widget/ticket_details_card.dart';

/// Displays detailed information about a SampleItem.
class TicketDetailsPage extends StatelessWidget {
  const TicketDetailsPage({super.key});

  static const routeName = '/ticket/detail';

  @override
  Widget build(BuildContext context) {
    final ticket = ModalRoute.of(context)!.settings.arguments as Ticket;

    return Scaffold(appBar: AppBar(), body: TicketDetailsCard(ticket: ticket));
  }
}
