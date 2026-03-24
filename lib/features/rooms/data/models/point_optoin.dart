class PointOption {
  final String id;
  final int pointValue;

  PointOption({required this.id, required this.pointValue});

  factory PointOption.fromJson(Map<String, dynamic> json) =>
      PointOption(
        id: json['id'] ?? '',
        pointValue: json['point_value'] ?? 0,
      );
}
