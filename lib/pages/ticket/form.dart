import 'package:flutter/material.dart';
import 'package:ticket/api/ticket.dart';
import 'package:ticket/model/ticket.dart';
import 'package:ticket/utils/show_loading_dialog.dart';
import 'package:ticket/utils/show_success_dialog.dart';

class TicketFormPayload {
  final String title;

  final Ticket? ticket;

  const TicketFormPayload({
    required this.title,
    this.ticket,
  });
}

class TicketFormPage extends StatelessWidget {
  static const routeName = "/ticket/form";

  const TicketFormPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final payload =
        ModalRoute.of(context)!.settings.arguments as TicketFormPayload;
    var title = payload.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: _TicketForm(
          ticket: payload.ticket,
        ),
      ),
    );
  }
}

class _TicketForm extends StatefulWidget {
  final Ticket? ticket;

  const _TicketForm({
    Key? key,
    this.ticket,
  }) : super(key: key);

  @override
  State<_TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<_TicketForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _topicController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    _topicController = TextEditingController(text: widget.ticket?.topic);
    _descriptionController =
        TextEditingController(text: widget.ticket?.description);
    super.initState();
  }

  @override
  void dispose() {
    _topicController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateTopic(String? topic) {
    return topic == null || topic.isEmpty ? "Please enter topic" : null;
  }

  String? _validateDescription(String? description) {
    return description == null || description.isEmpty
        ? "Please enter description"
        : null;
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    widget.ticket == null ? _issueTicket() : _updateTicket();
  }

  void _issueTicket() {
    var topic = _topicController.text;
    var description = _descriptionController.text;

    showLoadingDialog(context: context, text: 'Submitting Ticket...');
    ticketApi
        .create(
      topic: topic,
      description: description,
    )
        .then(
      (message) {
        Navigator.pop(context);
        showSuccessDialog(context: context, title: 'Success', content: message)
            .then((_) => Navigator.pop(context, 'refresh'));
      },
    );
  }

  void _updateTicket() {
    var topic = _topicController.text;
    var description = _descriptionController.text;

    showLoadingDialog(context: context, text: 'Updating Ticket...');
    ticketApi
        .update(
      id: widget.ticket!.id!,
      topic: topic,
      description: description,
    )
        .then(
      (message) {
        Navigator.pop(context);
        showSuccessDialog(context: context, title: 'Success', content: message)
            .then((_) => Navigator.pop(context, 'refresh'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxedSpace = SizedBox(height: 16);
    var textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _topicController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Enter Topic",
                  ),
                  validator: _validateTopic,
                  keyboardType: TextInputType.emailAddress,
                ),
                sizedBoxedSpace,
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Enter Description",
                  ),
                  validator: _validateDescription,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 5,
                ),
                sizedBoxedSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          inherit: true,
                          fontSize: textTheme.bodyLarge!.fontSize,
                          color: textTheme.bodyLarge!.color,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      child: Text(
                        widget.ticket == null ? 'Submit' : 'Update',
                        style: TextStyle(
                          inherit: true,
                          fontSize: textTheme.bodyLarge!.fontSize,
                        ),
                      ),
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
