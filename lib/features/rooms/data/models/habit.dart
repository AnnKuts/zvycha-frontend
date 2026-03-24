class Habit {
  final String id;
  final String name;
  final String pointsId;
  final String roomId;

  Habit({
    required this.id,
    required this.name,
    required this.pointsId,
    required this.roomId,
  });

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    pointsId: json['points_id'] ?? '',
    roomId: json['room_id'] ?? '',
  );
}
