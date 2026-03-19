import 'package:flutter/material.dart';
import 'destination_detail_page.dart';

import '../../data/datasources/local/destination_local_datasource.dart';
import '../../data/repositories/destination_repository_impl.dart';
import '../../domain/entities/destination.dart';
import '../../domain/usecases/get_destinations.dart';

class DestinationsPage extends StatefulWidget {
  const DestinationsPage({super.key});

  @override
  State<DestinationsPage> createState() => _DestinationsPageState();
}

class _DestinationsPageState extends State<DestinationsPage> {
  late final GetDestinations _getDestinations;
  List<Destination> _destinations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    final localDataSource = DestinationLocalDataSourceImpl();
    final repository = DestinationRepositoryImpl(
      localDataSource: localDataSource,
    );
    _getDestinations = GetDestinations(repository);

    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    try {
      final result = await _getDestinations();
      setState(() {
        _destinations = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocurrió un error al cargar los destinos.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinos turísticos'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!),
      );
    }

    if (_destinations.isEmpty) {
      return const Center(
        child: Text('No hay destinos disponibles.'),
      );
    }

    return ListView.separated(
      itemCount: _destinations.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final destination = _destinations[index];

        return ListTile(
          leading: CircleAvatar(
            child: Text(destination.name.substring(0, 1)),
          ),
          title: Text(destination.name),
          subtitle: Text(
            '${destination.category} • ${destination.locationName}',
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DestinationDetailPage(
                  destination: destination,
                ),
              ),
            );
          },
        );
      },
    );
  }
}