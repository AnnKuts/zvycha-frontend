import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/friends_notifier.dart';

class FriendsSection extends StatelessWidget {
  final FriendsNotifier notifier;
  const FriendsSection({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.25),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
            child: Text(
              'Friends (${notifier.friends.length})',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.gray300),
          ListView.builder(
            shrinkWrap: true,
            itemCount: notifier.friends.length,
            itemBuilder: (context, index) {
              final friend = notifier.friends[index];
              return _FriendCard(
                name: friend.username,
                onDelete: () {
                  // ЛОГІКА ВИДАЛЕННЯ
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FriendCard extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;

  const _FriendCard({
    required this.name,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 10,
          ),
          title: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete,
              color: AppColors.primary,
            ),
          ),
        ),
        const Divider(
          height: 1,
          color: AppColors.gray300,
          indent: 24,
          endIndent: 24,
        ),
      ],
    );
  }
}
