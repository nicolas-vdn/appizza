class Place {
  final double lat;
  final double lng;
  final String name;
  final String vicinity;

  Place({required this.lat, required this.lng, required this.name, required this.vicinity});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      lat: json['geometry']['location']['lat'],
      lng: json['geometry']['location']['lng'],
      name: json['formatted_address'],
      vicinity: json['vicinity'],
    );
  }
}
