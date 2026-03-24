import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/friends_notifier.dart';

class InvitationsSection extends StatelessWidget {
  final FriendsNotifier notifier;
  const InvitationsSection({super.key, required this.notifier});

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
              'Invitations (${notifier.incomingRequests.length})',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.gray300),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: notifier.incomingRequests.length,
              itemBuilder: (context, index) {
                final req = notifier.incomingRequests[index];
                final String userName = notifier.userNamesCache[req.creatorId] ?? "Unknown User";
                return _InvitationCard(
                  requestId: req.id,
                  userName: userName,
                  notifier: notifier,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final String requestId;
  final String userName;
  final FriendsNotifier notifier;

  const _InvitationCard({
    required this.requestId,
    required this.userName,
    required this.notifier,
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
            userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: _InviteActionButton(
                  icon: Icons.close,
                  color: AppColors.gray100,
                  onTap: () => notifier.declineRequest(requestId),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 28,
                height: 28,
                child: _InviteActionButton(
                  icon: Icons.check,
                  color: AppColors.gray100,
                  onTap: () => notifier.acceptRequest(requestId),
                ),
              ),
            ],
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

class _InviteActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const _InviteActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: size,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
