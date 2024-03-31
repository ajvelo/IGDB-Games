import 'package:flutter/material.dart';

class GameModeDialog extends StatelessWidget {
  final List<String> gameModes;

  const GameModeDialog({super.key, required this.gameModes});

  Widget _buildGameModeButton(BuildContext context, String mode) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, mode);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(mode, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text('Modes:', style: Theme.of(context).textTheme.bodyLarge),
          Spacer(),
          const Icon(
            Icons.gamepad,
            color: Colors.blue,
            size: 30.0,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: gameModes
            .map((mode) => _buildGameModeButton(context, mode))
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.red)),
        ),
      ],
    );
  }
}
