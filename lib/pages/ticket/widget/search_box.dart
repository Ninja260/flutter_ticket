import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket/view_model/ticket_list_page_vm.dart';

class SearchBox extends StatefulWidget {
  final TextEditingController inputControl;
  final FocusNode focusNode;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String hintText;

  const SearchBox({
    Key? key,
    required this.inputControl,
    required this.focusNode,
    required this.refreshIndicatorKey,
    required this.scaffoldKey,
    required this.hintText,
  }) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  Timer? _timer;

  void _handleSearchInputChange(value) {
    _timer?.cancel();
    var provider = context.read<TicketListPageVM>();
    var hasText = provider.hasText;
    var hasValue = widget.inputControl.text.isNotEmpty;
    if (hasValue != hasText) {
      provider.setHasText(hasValue);
    }

    _timer = Timer(const Duration(milliseconds: 500), () {
      widget.refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    var hasText = context.select((TicketListPageVM vm) => vm.hasText);
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.inputControl,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: InputBorder.none,
        icon: IconButton(
          icon: const Icon(Icons.dehaze),
          onPressed: () {
            widget.scaffoldKey.currentState!.openDrawer();
          },
        ),
        suffixIcon: _getIcon(hasText),
      ),
      onChanged: _handleSearchInputChange,
    );
  }

  Widget? _getIcon(bool hasText) {
    if (hasText) {
      return IconButton(
        onPressed: () {
          widget.inputControl.clear();
          _handleSearchInputChange('');
        },
        icon: const Icon(Icons.cancel),
      );
    }

    return null;
  }
}
