import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../friends/presentations/providers/friends_notifier.dart';
import '../../data/models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goNamed(
        AppPages.roomDetails.name,
        pathParameters: {'roomId': room.id},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
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
        child: ListTile(
          leading: Image.asset(
            'assets/images/pet/pixil-frame-0.png',
            height: 60,
          ),
          title: Text(
            room.name,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Consumer2<AuthNotifier, FriendsNotifier>(
            builder: (context, auth, friends, _) {
              final partnerId = room.creatorId == auth.userId
                  ? room.visitorId
                  : room.creatorId;
              final partnerName =
                  friends.userNamesCache[partnerId] ??
                  'Loading...';

              if (!friends.userNamesCache.containsKey(
                partnerId,
              )) {
                Future.microtask(
                  () => friends.fetchUsernamesByIds([partnerId]),
                );
              }
              return Text(
                partnerName,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w300,
                ),
              );
            },
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
