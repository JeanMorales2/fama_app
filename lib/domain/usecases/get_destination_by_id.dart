import '../entities/destination.dart';
import '../repositories/destination_repository.dart';

class GetDestinationById {
  final DestinationRepository repository;

  GetDestinationById(this.repository);

  Future<Destination?> call(int id) async {
    return await repository.getDestinationById(id);
  }
}