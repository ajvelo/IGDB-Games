import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/presentation/cubit/game/game_cubit.dart';

class FilterOptionsDialog extends StatelessWidget {
  const FilterOptionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: (Status.values)
                  .map(
                    (status) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildFilterOption(context, status.displayName,
                          Icons.change_circle_outlined, () {
                        context.read<GameCubit>().filterBy(
                            filter: FilterEnum.status,
                            status: status,
                            isAscending: true);
                        Navigator.of(context).pop();
                      }, status),
                    ),
                  )
                  .toList(),
            ),
          ),
          _buildFilterOption(context, 'Name (A to Z)', Icons.sort_by_alpha, () {
            context.read<GameCubit>().filterBy(
                filter: FilterEnum.name, status: null, isAscending: true);
            Navigator.of(context).pop();
          }, null),
          _buildFilterOption(context, 'Name (Z to A)', Icons.star, () {
            context.read<GameCubit>().filterBy(
                filter: FilterEnum.ranking, status: null, isAscending: false);
            Navigator.of(context).pop();
          }, null),
          _buildFilterOption(context, 'Rank (High to Low)', Icons.sort_by_alpha,
              () {
            context.read<GameCubit>().filterBy(
                filter: FilterEnum.ranking, status: null, isAscending: true);
            Navigator.of(context).pop();
          }, null),
          _buildFilterOption(context, 'Rank (Low to High)', Icons.star, () {
            context.read<GameCubit>().filterBy(
                filter: FilterEnum.ranking, status: null, isAscending: false);
            Navigator.of(context).pop();
          }, null),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Filter By:', style: Theme.of(context).textTheme.headlineMedium),
        IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildFilterOption(BuildContext context, String title, IconData icon,
      VoidCallback onTap, Status? status) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color:
              status != null ? status.badgeColor : Colors.blue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28.0,
            ),
            const SizedBox(width: 8.0),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
