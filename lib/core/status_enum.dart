// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum Status {
  released,
  alpha,
  beta,
  early_access,
  offline,
  cancelled,
  rumored,
  delisted,
}

extension StatusExtension on Status {
  int get value {
    switch (this) {
      case Status.released:
        return 0;
      case Status.alpha:
        return 2;
      case Status.beta:
        return 3;
      case Status.early_access:
        return 4;
      case Status.offline:
        return 5;
      case Status.cancelled:
        return 6;
      case Status.rumored:
        return 7;
      case Status.delisted:
        return 8;
      default:
        throw Exception("Invalid Status");
    }
  }

  String get displayName {
    switch (this) {
      case Status.released:
        return 'Released';
      case Status.alpha:
        return 'Alpha';
      case Status.beta:
        return 'Beta';
      case Status.early_access:
        return 'Early Access';
      case Status.offline:
        return 'Offline';
      case Status.cancelled:
        return 'Cancelled';
      case Status.rumored:
        return 'Rumored';
      case Status.delisted:
        return 'Delisted';
      default:
        throw Exception("Invalid Status");
    }
  }

  Color get badgeColor {
    switch (this) {
      case Status.released:
        return Colors.green;
      case Status.alpha:
        return Colors.blue;
      case Status.beta:
        return Colors.orange;
      case Status.early_access:
        return Colors.yellow;
      case Status.offline:
        return Colors.grey;
      case Status.cancelled:
        return Colors.red;
      case Status.rumored:
        return Colors.purple;
      case Status.delisted:
        return Colors.black;
      default:
        throw Exception("Invalid Status");
    }
  }
}
