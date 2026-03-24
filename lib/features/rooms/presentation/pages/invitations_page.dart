import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../friends/presentations/providers/friends_notifier.dart';
import '../providers/rooms_notifier.dart';
import '../widgets/invitations_tab.dart';
import 'package:provider/provider.dart';

class InvitationsPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const InvitationsPage({
    super.key,
    required this.navigationShell,
  });

  @override
  State<InvitationsPage> createState() =>
      _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final roomsNotifie = Provider.of<RoomsNotifier>(
        context,
        listen: false,
      );
      final friendsNotifie = Provider.of<FriendsNotifier>(
        context,
        listen: false,
      );

      await roomsNotifie.loadInitialData();

      final allRoomUserIds = [
        ...roomsNotifie.incomingRequests.map((r) => r.creatorId),
        ...roomsNotifie.outgoingRequests.map((r) => r.visitorId),
      ].whereType<String>().toList();

      if (allRoomUserIds.isNotEmpty) {
        await friendsNotifie.fetchUsernamesByIds(allRoomUserIds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Invitations',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              InvitationsTab(
                navigationShell: widget.navigationShell,
              ),
              const SizedBox(height: 20),
              Expanded(child: widget.navigationShell),
            ],
          ),
        ),
      ),
    );
  }
}
