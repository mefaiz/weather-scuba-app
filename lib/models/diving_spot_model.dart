class DivingSpot {
  final String name;
  final double latitude;
  final double longitude;
  final String description;

  DivingSpot({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
  });

  factory DivingSpot.fromJson(Map<String, dynamic> json) {
    return DivingSpot(
      name: json['name'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      description: json['description'],
    );
  }
}
