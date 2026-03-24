enum CreationStatus {
  pending,
  declined,
  accepted,
  unknown;

  static CreationStatus fromString(String status) {
    return CreationStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == status.toUpperCase(),
      orElse: () => CreationStatus.unknown,
    );
  }
}

class Room {
  final String id;
  final String name;
  final String creatorId;
  final String visitorId;
  final bool roomStatus;
  final CreationStatus creationStatus;

  Room({
    required this.id,
    required this.name,
    required this.creatorId,
    required this.visitorId,
    required this.roomStatus,
    required this.creationStatus,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    creatorId: json['creator_id'] ?? '',
    visitorId: json['visitor_id'] ?? '',
    roomStatus: json['room_status'] ?? true,
    creationStatus: CreationStatus.fromString(
      json['creation_status'] ?? '',
    ),
  );
}
