class ChargerStation {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String distance;

  ChargerStation({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory ChargerStation.fromJson(Map<String, dynamic> json) {
    return ChargerStation(
      name: json['AddressInfo']['Title'] ?? 'Unknown',
      address: json['AddressInfo']['AddressLine1'] ?? 'Unknown Address',
      latitude: json['AddressInfo']['Latitude'] ?? 0.0,
      longitude: json['AddressInfo']['Longitude'] ?? 0.0,
      distance: json['AddressInfo']['Distance']?.toString() ?? 'Unknown',
    );
  }
}
