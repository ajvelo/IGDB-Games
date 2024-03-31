import 'package:flutter/material.dart';
import 'package:igdb_games/core/status_enum.dart';

class StatusBadge extends StatelessWidget {
  final Status status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(status.displayName,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white)),
    );
  }
}
