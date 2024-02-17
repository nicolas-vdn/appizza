class PlaceSearch {
  final String? description;
  final String? placeId;
  final String? reference;

  PlaceSearch({
    this.description,
    this.placeId,
    this.reference,
  });

  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
      description: json['description'],
      placeId: json['place_id'],
      reference: json['reference'],
    );
  }
}
