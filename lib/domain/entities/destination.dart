class Destination {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String mapImageUrl;
  final String category;
  final String locationName;
  final double latitude;
  final double longitude;

  const Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.mapImageUrl,
    required this.category,
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });
}