import 'package:flutter/material.dart';

Color getBadgeColor(String status) {
  switch (status) {
    case 'REVIEW':
      return Colors.blue;
    case 'INQUIRY':
      return Colors.red;
    case 'PROCEED':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
