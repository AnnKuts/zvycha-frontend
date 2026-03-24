import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/labeled_section.dart';
import '../../../../core/widgets/text_field_without_label.dart';
import '../../data/models/point_optoin.dart';

class AddHabitDialog extends StatefulWidget {
  final List<PointOption> options;

  const AddHabitDialog({super.key, required this.options});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final TextEditingController _controller =
      TextEditingController();
  String? selectedPointsId;

  @override
  void initState() {
    super.initState();
    // Автоматично вибираємо перший варіант, якщо він є
    if (widget.options.isNotEmpty) {
      selectedPointsId = widget.options.first.id;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: AppColors.background,
      title: Text(
        'Add A Habit',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LabeledSection(
              label: 'Your habbit:',
              child: AppTextWithoutLabel(
                hint: 'Drink water',
                controller: _controller,
                onChanged: (value) => setState(() {}),
              ),
            ),

            const SizedBox(height: 24),

            LabeledSection(
              label: 'Points for completing:',
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: widget.options.map((option) {
                  final bool isSelected =
                      selectedPointsId == option.id;
                  return GestureDetector(
                    onTap: () => setState(
                      () => selectedPointsId = option.id,
                    ),
                    child: Column(
                      children: [
                        Text('${option.pointValue}'),
                        Radio<String>(
                          value: option.id,
                          groupValue: selectedPointsId,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setState(
                            () => selectedPointsId = val,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => context.pop(),
                text: 'Quit',
                variant: AppButtonVariant.outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: 'Add',
                onPressed:
                    (_controller.text.trim().isEmpty ||
                        selectedPointsId == null)
                    ? null
                    : () {
                        final option = widget.options.firstWhere(
                          (o) => o.id == selectedPointsId,
                        );
                        context.pop({
                          'name': _controller.text.trim(),
                          'points_id': selectedPointsId,
                          'value': option.pointValue,
                        });
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
