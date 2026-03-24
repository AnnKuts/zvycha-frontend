import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../friends/presentations/providers/friends_notifier.dart';
import '../providers/rooms_notifier.dart';

class InvitationsReceivedPage extends StatelessWidget {
  const InvitationsReceivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<RoomsNotifier, FriendsNotifier>(
      builder: (context, roomsNotifier, friendsNotifier, child) {
        final received = roomsNotifier.incomingRequests;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You received: ${received.length}',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: received.length,
                itemBuilder: (context, index) {
                  final room = received[index];
                  final senderName =
                      friendsNotifier.userNamesCache[room
                          .creatorId] ??
                      "error";
                  return _InvitationCard(
                    title: room.name,
                    subtitle: 'From: $senderName',
                    onTap: () {
                      context.pushNamed(
                        AppPages.acceptInvitation.name,
                        pathParameters: {'roomId': room.id},
                        extra: {
                          'roomName': room.name,
                          'senderName': senderName,
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _InvitationCard({
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.gray500),
        ),
        trailing:
            trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.primary,
            ),
      ),
    );
  }
}
