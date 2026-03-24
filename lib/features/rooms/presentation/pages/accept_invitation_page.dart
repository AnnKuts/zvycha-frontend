import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zvycha_frontend/core/navigation/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/labeled_section.dart';
import '../../../../core/widgets/text_field_without_label.dart';
import '../providers/rooms_notifier.dart';
import '../widgets/add_habit_dialog.dart';

class AcceptInvitationPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String senderName;

  const AcceptInvitationPage({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.senderName,
  });

  @override
  State<AcceptInvitationPage> createState() =>
      _AcceptInvitationPageState();
}

class _AcceptInvitationPageState
    extends State<AcceptInvitationPage> {
  final TextEditingController _petNameController =
      TextEditingController();
  final List<Map<String, dynamic>> _selectedHabits = [];
  bool _isSubmitting = false;

  void _showAddHabitDialog() async {
    final notifier = context.read<RoomsNotifier>();

    if (notifier.pointOptions.isEmpty) {
      await notifier.loadInitialData();
    }

    final options = notifier.pointOptions;

    if (options.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Points is loading...')),
        );
      }
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddHabitDialog(options: options),
    );

    if (result != null) {
      setState(() => _selectedHabits.add(result));
    }
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      final habitsData = _selectedHabits
          .map(
            (h) => {
              'name': h['name'] as String,
              'points_id': h['points_id'] as String,
            },
          )
          .toList();
      await context.read<RoomsNotifier>().acceptRequest(
        widget.roomId,
        _petNameController.text,
        habitsData,
      );
      if (mounted) context.go(AppPages.rooms.path);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _decline() async {
    setState(() => _isSubmitting = true);
    try {
      await context.read<RoomsNotifier>().declineRequest(
        widget.roomId,
      );
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomsNotifier = context.watch<RoomsNotifier>();
    final bool hasRoomLimit =
        roomsNotifier.activeRooms.length >= 20;
    final bool canAccept =
        _selectedHabits.isNotEmpty &&
        _petNameController.text.isNotEmpty &&
        !hasRoomLimit &&
        !_isSubmitting;

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
              child: CustomHeader(title: 'Create A New Room'),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                children: [
                  LabeledSection(
                    label: 'Room name:',
                    child: Text(
                      widget.roomName,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  LabeledSection(
                    label: 'Friend:',
                    child: Text(
                      widget.senderName,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const _PetSelectionWidget(),
                  const SizedBox(height: 32),
                  LabeledSection(
                    label: 'Your pet name:',
                    child: AppTextWithoutLabel(
                      hint: 'Pumpkin',
                      controller: _petNameController,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _HabitsHeaderWidget(
                    count: _selectedHabits.length,
                    onAdd: _showAddHabitDialog,
                  ),
                  const SizedBox(height: 12),
                  _HabitsListWidget(
                    habits: _selectedHabits,
                    onDelete: (index) => setState(
                      () => _selectedHabits.removeAt(index),
                    ),
                  ),
                ],
              ),
            ),
            _FooterWidget(
              canAccept: canAccept,
              hasLimit: hasRoomLimit,
              isSubmitting: _isSubmitting,
              onAccept: _submit,
              onDecline: _decline,
            ),
          ],
        ),
      ),
    );
  }
}

class _PetSelectionWidget extends StatelessWidget {
  const _PetSelectionWidget();

  @override
  Widget build(BuildContext context) {
    return LabeledSection(
      label: 'Choose a pet:',
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/pet/pixil-frame-0.png',
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(
                    Icons.pets,
                    size: 80,
                    color: AppColors.primary,
                  ),
            ),
            Radio(
              value: 0,
              groupValue: 0,
              onChanged: (v) {},
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitsHeaderWidget extends StatelessWidget {
  final int count;
  final VoidCallback onAdd;

  const _HabitsHeaderWidget({
    required this.count,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add a habit: $count/5',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        if (count < 5)
          IconButton(
            icon: const Icon(
              Icons.add,
              color: AppColors.primary,
              size: 32,
            ),
            onPressed: onAdd,
          ),
      ],
    );
  }
}

class _HabitsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> habits;
  final Function(int) onDelete;

  const _HabitsListWidget({
    required this.habits,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: habits.asMap().entries.map((entry) {
        final String name = entry.value['name'] ?? '';
        final int value = entry.value['value'] ?? 0;

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              '$name ($value pts)',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: AppColors.primary,
                size: 24,
              ),
              onPressed: () => onDelete(entry.key),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _FooterWidget extends StatelessWidget {
  final bool canAccept;
  final bool hasLimit;
  final bool isSubmitting;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _FooterWidget({
    required this.canAccept,
    required this.hasLimit,
    required this.isSubmitting,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasLimit)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Limit reached!',
                style: TextStyle(color: Colors.red),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Decline',
                  variant: AppButtonVariant.outline,
                  onPressed: isSubmitting ? null : onDecline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  text: 'Accept',
                  onPressed: canAccept ? onAccept : null,
                  isLoading: isSubmitting,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
