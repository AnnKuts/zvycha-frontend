import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zvycha_frontend/core/widgets/labeled_section.dart';
import 'package:zvycha_frontend/features/auth/presentation/providers/auth_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../data/models/habit.dart';
import '../providers/rooms_notifier.dart';

class RoomDetailsPage extends StatefulWidget {
  final String roomId;

  const RoomDetailsPage({super.key, required this.roomId});

  @override
  State<RoomDetailsPage> createState() =>
      _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  String _getPetImagePath(double hpPercent) {
    if (hpPercent > 0.6) {
      return 'assets/images/pet/pixil-frame-0.png';
    } else if (hpPercent > 0) {
      return 'assets/images/pet/pixil-frame-1.png';
    } else {
      return 'assets/images/pet/pixil-frame-2.png';
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<RoomsNotifier>().loadRoomDetails(
        widget.roomId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<RoomsNotifier>();

    if (notifier.isLoading || notifier.currentPet == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pet = notifier.currentPet!;
    final double hpPercent = (pet.currentHp / pet.maxHp).clamp(
      0.0,
      1.0,
    );
    final room = notifier.activeRooms.firstWhere(
      (r) => r.id == widget.roomId,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: CustomHeader(title: room.name),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          _getPetImagePath(hpPercent),
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _HealthBar(
                          hpPercent: hpPercent,
                          currentHp: pet.currentHp,
                          maxHp: pet.maxHp,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  LabeledSection(
                    label: 'Habits',
                    child: Column(
                      children: notifier.currentHabits
                          .map(
                            (habit) => _HabitTile(
                              habit: habit,
                              roomId: widget.roomId,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthBar extends StatelessWidget {
  final double hpPercent;
  final int currentHp;
  final int maxHp;

  const _HealthBar({
    required this.hpPercent,
    required this.currentHp,
    required this.maxHp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 14,
          width: 240,
          decoration: BoxDecoration(
            color: AppColors.gray500,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: hpPercent,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$currentHp/$maxHp HP',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _HabitTile extends StatelessWidget {
  final Habit habit;
  final String roomId;

  const _HabitTile({required this.habit, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<RoomsNotifier>();
    final auth = context.read<AuthNotifier>();

    final progressList = notifier.habitsProgress[habit.id] ?? [];
    final room = notifier.activeRooms.firstWhere(
      (r) => r.id == roomId,
    );
    final partnerId = auth.userId == room.creatorId
        ? room.visitorId
        : room.creatorId;

    final now = DateTime.now();
    bool _isToday(DateTime date) =>
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    bool isCompletedByPartner = progressList.any(
      (p) => p.userId == partnerId && _isToday(p.createdAt),
    );
    bool isCompletedByUser = progressList.any(
      (p) => p.userId == auth.userId && _isToday(p.createdAt),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isCompletedByPartner
                ? AppColors.primary
                : AppColors.gray500,
            child: const Icon(
              Icons.person,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '+ ${notifier.getPointsValue(habit.pointsId)} points',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: isCompletedByUser
                ? null
                : () => notifier.checkHabit(habit.id, roomId),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCompletedByUser
                    ? AppColors.accentGreen
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompletedByUser
                      ? Colors.transparent
                      : AppColors.gray500,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.check,
                color: isCompletedByUser
                    ? Colors.white
                    : AppColors.gray300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
