import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/core/image_clipper.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/presentation/cubit/screenshot/screenshot_cubit.dart';
import 'package:igdb_games/presentation/cubit/screenshot/screenshot_state.dart';
import 'package:igdb_games/presentation/widgets/carousel_slider.dart';
import 'package:igdb_games/presentation/widgets/status_badge.dart';

class GameDetailPage extends StatefulWidget {
  final int id;
  final String name;
  final String summary;
  final String coverImageUrl;
  final String storyline;
  final double ranking;
  final Status status;

  const GameDetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.summary,
    required this.coverImageUrl,
    required this.storyline,
    required this.ranking,
    required this.status,
  });

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScreenshotCubit>().fetchScreenShots(gameId: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          _buildCoverImage(context),
          _buildContent(context),
          Positioned(bottom: 32, left: 16, right: 16, child: _buildBottomRow()),
        ],
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    return ClipPath(
      clipper: ImageClipper(),
      child: CachedNetworkImage(
        imageUrl: "https:${widget.coverImageUrl}",
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        placeholder: (context, url) => const SizedBox.shrink(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: 64, top: MediaQuery.of(context).size.height * 0.4),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Summary:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.summary,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Storyline:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.storyline,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Screenshots:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                BlocBuilder<ScreenshotCubit, ScreenShotState>(
                  builder: (context, state) {
                    if (state is ScreenShotLoadingState) {
                      return const CircularProgressIndicator();
                    } else if (state is ScreenShotLoadedState) {
                      return SizedBox(
                          height: 200,
                          child: CustomCarouselSlider(imageUrls: state.urls));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildBottomRow() {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber),
        const SizedBox(width: 4.0),
        Text(
          widget.ranking.toStringAsFixed(1),
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        StatusBadge(status: widget.status)
      ],
    );
  }
}
