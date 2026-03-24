class Pet {
  final String id;
  final String name;
  final String roomId;
  final int currentHp;
  final int maxHp;
  final bool isDead;

  Pet({
    required this.id,
    required this.name,
    required this.roomId,
    required this.currentHp,
    required this.maxHp,
    required this.isDead,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    roomId: json['room_id'] ?? '',
    currentHp: json['current_hp'] ?? 0,
    maxHp: json['max_hp'] ?? 0,
    isDead: json['is_dead'] ?? false,
  );
}
