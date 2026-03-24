import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/search_field.dart';
import '../providers/friends_notifier.dart';

class FriendsFindPage extends StatelessWidget {
  const FriendsFindPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendsNotifier>(
      builder: (context, notifier, child) {
        return Column(
          children: [
            AppSearchField(
              onSearch: (value) =>
                  notifier.searchNewPeople(value),
            ),
            const SizedBox(height: 16),
            if (notifier.isLoadingSearch)
              const Center(child: CircularProgressIndicator())
            else if (notifier.foundUsers.isNotEmpty)
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(
                          alpha: 0.25,
                        ),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    itemCount: notifier.foundUsers.length,
                    itemBuilder: (context, index) {
                      final user = notifier.foundUsers[index];
                      final bool isFriend = notifier.friends.any(
                        (friend) => friend.id == user.id,
                      );
                      final bool isSent = notifier
                          .outgoingRequests
                          .any((req) => req.userId == user.id);

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _UserFindCard(
                            username: user.username,
                            isSent: isSent,
                            isFriend: isFriend,
                            onAdd: () =>
                                notifier.sendInvitation(user.id),
                          ),
                          if (index <
                              notifier.foundUsers.length - 1)
                            const Divider(
                              height: 1,
                              color: AppColors.gray300,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _UserFindCard extends StatelessWidget {
  final String username;
  final bool isSent;
  final bool isFriend;
  final VoidCallback onAdd;

  const _UserFindCard({
    required this.username,
    required this.isSent,
    required this.isFriend,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        username,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isFriend
          ? const SizedBox.shrink() // Порожній віджет, якщо вже в друзях
          : SizedBox(
              width: 108,
              height: 36,
              child: isSent
                  ? const _SentButton()
                  : _AddButton(onTap: onAdd),
            ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 16, color: AppColors.white),
          SizedBox(width: 4),
          Text(
            'Add',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _SentButton extends StatelessWidget {
  const _SentButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color: AppColors.white,
          ),
          SizedBox(width: 4),
          Text(
            'Sent',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
