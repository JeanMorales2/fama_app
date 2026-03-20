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
              description: 'Hermosa playa en Nicaragua.',
              imageUrl: 'assets/images/san_juan_del_sur.jpg',
              mapImageUrl: 'assets/maps/san_juan_del_sur_map.png',
              category: 'Playa',
              locationName: 'Rivas, Nicaragua',
              latitude: 11.252,
              longitude: -85.870,
            ),
            const DestinationModel(
              id: 2,
              name: 'Granada',
              description: 'Ciudad colonial histórica.',
              imageUrl: 'assets/images/granada.jpg',
              mapImageUrl: 'assets/maps/granada_map.png',
              category: 'Cultural',
              locationName: 'Granada, Nicaragua',
              latitude: 11.934,
              longitude: -85.956,
            ),
            const DestinationModel(
              id: 3,
              name: 'Jinotega',
              description: 'Destino montañoso reconocido por su clima fresco y paisajes naturales.',
              imageUrl: 'assets/images/jinotega.jpg',
              mapImageUrl: 'assets/maps/jinotega_map.png',
              category: 'Naturaleza',
              locationName: 'Jinotega, Nicaragua',
              latitude: 13.091,
              longitude: -86.002,
            ),
            const DestinationModel(
              id: 4,
              name: 'León',
              description: 'Ciudad histórica y cultural, famosa por su arquitectura y tradición universitaria.',
              imageUrl: 'assets/images/leon.jpg',
              mapImageUrl: 'assets/maps/leon_map.png',
              category: 'Cultural',
              locationName: 'León, Nicaragua',
              latitude: 12.437,
              longitude: -86.879,
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