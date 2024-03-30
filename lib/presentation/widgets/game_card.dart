import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/presentation/widgets/status_badge.dart';

class GameCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String summary;
  final double ranking;
  final Status status;

  const GameCard(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.summary,
      required this.ranking,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            child: CachedNetworkImage(
              imageUrl: "https:$imageUrl",
              fit: BoxFit.fitWidth,
              width: double.infinity,
              height: 150.0,
              placeholder: (context, url) => const SizedBox.shrink(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  summary,
                  style: const TextStyle(fontSize: 14.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4.0),
                    Text(
                      ranking.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    StatusBadge(status: status)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
