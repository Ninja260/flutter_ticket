import 'package:flutter/foundation.dart';
import 'package:ticket/api/ticket.dart';
import 'package:ticket/model/ticket.dart';

class TicketListPageVM extends ChangeNotifier {
  String type = 'concern';

  List<Ticket> ticketList = [];

  bool hasText = false;

  Future<void> refreshList(String search) async {
    ticketList = await ticketApi.getList(type: type, search: search);
    notifyListeners();
  }

  changeType(String type) {
    // type only must be 'concern' and 'all' currently
    this.type = type;
    notifyListeners();
  }

  setHasText(bool value) {
    hasText = value;
    notifyListeners();
  }

  reset() {
    type = 'concern';
    ticketList = [];
    hasText = false;
    notifyListeners();
  }
}
