// import 'package:ticket/model/response.dart';
import 'package:ticket/model/log.dart';
import 'package:ticket/model/ticket.dart';
import 'package:ticket/utils/http_util.dart';

const ticketUrl = '/ticket';
const ticketIdUrl = '/ticket/:id';
const ticketApproveUrl = '/ticket/:id/approve';
const ticketInquireUrl = '/ticket/:id/inquire';
const ticketGetLogsUrl = '/ticket/:id/log';

class _TicketApi {
  const _TicketApi();

  Future<List<Ticket>> getList({
    required String type,
    required String search,
  }) async {
    var res = await HttpUtil.get(ticketUrl, {
      "type": type,
      "search": search,
    });
    var data = res.body["data"];
    return List<Ticket>.from(data.map((item) => Ticket.fromJson(item)));
  }

  Future<Ticket> getById(String id) async {
    var res = await HttpUtil.get(ticketIdUrl.replaceAll(":id", id));
    var data = res.body["data"];

    return Ticket.fromJson(data);
  }

  Future<List<Log>> getLogs(String id) async {
    var res = await HttpUtil.get(ticketGetLogsUrl.replaceAll(':id', id));
    var data = res.body["data"];

    return List<Log>.from(data.map((item) => Log.fromJson(item)));
  }

  Future<String> create({
    required String topic,
    required String description,
  }) async {
    var res = await HttpUtil.post(ticketUrl, {
      "topic": topic,
      "description": description,
    });
    return res.body["data"]["message"];
  }

  Future<String> update({
    required String id,
    required String topic,
    required String description,
  }) async {
    var res = await HttpUtil.put(ticketIdUrl.replaceAll(":id", id), {
      "topic": topic,
      "description": description,
    });
    return res.body["data"]["message"];
  }

  Future<String> approve({required String id}) async {
    var res = await HttpUtil.post(ticketApproveUrl.replaceAll(":id", id), {});
    return res.body["data"]["message"];
  }

  Future<String> inquire({required String id}) async {
    var res = await HttpUtil.post(ticketInquireUrl.replaceAll(":id", id), {});
    return res.body["data"]["message"];
  }

  Future<String> delete({required String id}) async {
    var res = await HttpUtil.delete(ticketIdUrl.replaceAll(":id", id));
    return res.body["data"]["message"];
  }
}

const ticketApi = _TicketApi();
