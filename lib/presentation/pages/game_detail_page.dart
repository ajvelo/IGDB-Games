import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/core/image_clipper.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';
import 'package:igdb_games/presentation/cubit/screenshot/screenshot_cubit.dart';
import 'package:igdb_games/presentation/cubit/screenshot/screenshot_state.dart';
import 'package:igdb_games/presentation/widgets/carousel_slider.dart';
import 'package:igdb_games/presentation/widgets/game_mode_dialog.dart';
import 'package:igdb_games/presentation/widgets/status_badge.dart';

class GameDetailPage extends StatefulWidget {
  final Game game;

  const GameDetailPage({super.key, required this.game});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScreenshotCubit>().fetchScreenShots(gameId: widget.game.id);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Container(
          color: Colors.black,
          child: Text(
            widget.game.name,
            maxLines: 2,
            style: textTheme.headlineLarge!.copyWith(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.gamepad),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return GameModeDialog(
                    gameModes: widget.game.gameModes,
                  );
                },
              );
            },
          ),
        ],
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          _buildCoverImage(context),
          _buildContent(context, textTheme),
          Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: _buildBottomRow(textTheme)),
        ],
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    return ClipPath(
      clipper: ImageClipper(),
      child: Opacity(
        opacity: 0.6,
        child: CachedNetworkImage(
          imageUrl: "https:${widget.game.imageCover}",
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          placeholder: (context, url) => const SizedBox.shrink(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
          top: MediaQuery.of(context).size.height * 0.4),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary:',
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.game.summary,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Storyline:',
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.game.storyLine,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Screenshots:',
                  style: textTheme.headlineMedium,
                ),
                BlocBuilder<ScreenshotCubit, ScreenShotState>(
                  builder: (context, state) {
                    if (state is ScreenShotLoadingState) {
                      return const CircularProgressIndicator();
                    } else if (state is ScreenShotLoadedState) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
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

  Widget _buildBottomRow(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber),
          const SizedBox(width: 4.0),
          Text(
            widget.game.totalRating.toStringAsFixed(1),
            style: textTheme.headlineMedium,
          ),
          const Spacer(),
          StatusBadge(status: widget.game.status)
        ],
      ),
    );
  }
}
