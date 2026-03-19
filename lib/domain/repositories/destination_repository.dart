import '../entities/destination.dart';

abstract class DestinationRepository {
  Future<List<Destination>> getDestinations();
  Future<Destination?> getDestinationById(int id);
}