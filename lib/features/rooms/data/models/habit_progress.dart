class HabitProgress {
  final String id;
  final String userId;
  final String habitId;
  final DateTime createdAt;

  HabitProgress({
    required this.id,
    required this.userId,
    required this.habitId,
    required this.createdAt,
  });

  factory HabitProgress.fromJson(Map<String, dynamic> json) {
    return HabitProgress(
      id: json['id'],
      userId: json['user_id'],
      habitId: json['habbit_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
