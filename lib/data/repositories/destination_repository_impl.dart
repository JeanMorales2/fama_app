import '../../domain/entities/destination.dart';
import '../../domain/repositories/destination_repository.dart';
import '../datasources/local/destination_local_datasource.dart';

class DestinationRepositoryImpl implements DestinationRepository {
  final DestinationLocalDataSource localDataSource;

  DestinationRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Destination>> getDestinations() async {
    return await localDataSource.getDestinations();
  }

  @override
  Future<Destination?> getDestinationById(int id) async {
    final destinations = await localDataSource.getDestinations();

    try {
      return destinations.firstWhere((destination) => destination.id == id);
    } catch (_) {
      return null;
    }
  }
}