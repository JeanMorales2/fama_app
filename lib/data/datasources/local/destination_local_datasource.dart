import 'package:sqflite/sqflite.dart';

import '../../models/destination_model.dart';
import 'app_database.dart';

abstract class DestinationLocalDataSource {
  Future<List<DestinationModel>> getDestinations();
}

class DestinationLocalDataSourceImpl implements DestinationLocalDataSource {
  final AppDatabase appDatabase;

  DestinationLocalDataSourceImpl({required this.appDatabase});

  @override
  Future<List<DestinationModel>> getDestinations() async {
    final db = await appDatabase.database;

    final maps = await db.query('destinations');

    if (maps.isEmpty) {
      await _seedDestinations(db);
      final seededMaps = await db.query('destinations');

      return seededMaps
          .map((map) => DestinationModel.fromJson(map))
          .toList();
    }

    return maps.map((map) => DestinationModel.fromJson(map)).toList();
  }

  Future<void> _seedDestinations(Database db) async {
    final destinations = [
      const DestinationModel(
        id: 1,
        name: 'San Juan del Sur',
        description: 'Hermosa playa en Nicaragua',
        imageUrl: 'https://example.com/sanjuan.jpg',
        category: 'Playa',
        locationName: 'Rivas, Nicaragua',
        latitude: 11.252,
        longitude: -85.870,
      ),
      const DestinationModel(
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

    for (final destination in destinations) {
      await db.insert(
        'destinations',
        destination.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}