enum RequestStatus {
  pending,
  declined,
  accepted,
  unknown;

  static RequestStatus fromString(String status) {
    return RequestStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == status.toUpperCase(),
      orElse: () => RequestStatus.unknown,
    );
  }
}

class FriendRequest {
  final String id;
  final String creatorId;
  final String userId;
  final RequestStatus status;

  FriendRequest({
    required this.id,
    required this.creatorId,
    required this.userId,
    required this.status,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'],
      creatorId: json['creator_id'],
      userId: json['user_id'],
      status: RequestStatus.fromString(json['status'] ?? ''),
    );
  }
}
