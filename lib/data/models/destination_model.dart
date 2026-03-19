import '../../domain/entities/destination.dart';

class DestinationModel extends Destination {
  const DestinationModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.category,
    required super.locationName,
    required super.latitude,
    required super.longitude,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      locationName: json['locationName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}