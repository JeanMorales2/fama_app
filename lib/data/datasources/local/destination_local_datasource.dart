import '../../models/destination_model.dart';

abstract class DestinationLocalDataSource {
  Future<List<DestinationModel>> getDestinations();
}

class DestinationLocalDataSourceImpl implements DestinationLocalDataSource {
  @override
  Future<List<DestinationModel>> getDestinations() async {
    // Simulación de datos locales (luego reemplazar por SQLite)
    return [
      DestinationModel(
        id: 1,
        name: 'San Juan del Sur',
        description: 'Hermosa playa en Nicaragua',
        imageUrl: 'https://example.com/sanjuan.jpg',
        category: 'Playa',
        locationName: 'Rivas, Nicaragua',
        latitude: 11.252,
        longitude: -85.870,
      ),
      DestinationModel(
        id: 2,
        name: 'Granada',
        description: 'Ciudad colonial histórica',
        imageUrl: 'https://example.com/granada.jpg',
        category: 'Cultural',
        locationName: 'Granada, Nicaragua',
        latitude: 11.934,
        longitude: -85.956,
      ),
    ];
  }
}