import '../entities/destination.dart';
import '../repositories/destination_repository.dart';

class GetDestinations {
  final DestinationRepository repository;

  GetDestinations(this.repository);

  Future<List<Destination>> call() async {
    return await repository.getDestinations();
  }
}