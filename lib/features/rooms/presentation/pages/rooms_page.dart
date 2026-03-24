import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zvycha_frontend/features/auth/presentation/providers/auth_notifier.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/rooms_notifier.dart';
import '../widgets/room_card.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32,
            left: 24,
            right: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<AuthNotifier>(
                builder: (context, auth, child) {
                  return Text(
                    'Hi, ${auth.username ?? 'User'}!',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge,
                  );
                },
              ),
              
              const SizedBox(height: 16),

              Consumer<RoomsNotifier>(
                builder: (context, notifier, child) {
                  final activeCount =
                      notifier.activeRooms.length;
                  return Text(
                    'You have: $activeCount/20 rooms.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              Expanded(
                child: Consumer<RoomsNotifier>(
                  builder: (context, notifier, child) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: notifier.activeRooms.length,
                      itemBuilder: (context, index) {
                        final room = notifier.activeRooms[index];
                        return RoomCard(room: room);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer<RoomsNotifier>(
        builder: (context, notifier, child) {
          return notifier.activeRooms.length < 20
              ? FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  onPressed: () =>
                      context.push(AppPages.createRoom.path),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
