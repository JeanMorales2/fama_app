import 'package:flutter/material.dart';
import 'destination_detail_page.dart';

import '../../data/datasources/local/destination_local_datasource.dart';
import '../../data/repositories/destination_repository_impl.dart';
import '../../domain/entities/destination.dart';
import '../../domain/usecases/get_destinations.dart';
import '../../data/datasources/local/app_database.dart';

class DestinationsPage extends StatefulWidget {
  const DestinationsPage({super.key});

  @override
  State<DestinationsPage> createState() => _DestinationsPageState();
}

class _DestinationsPageState extends State<DestinationsPage> {
  late final GetDestinations _getDestinations;
  List<Destination> _destinations = [];
  List<Destination> _filteredDestinations = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final localDataSource = DestinationLocalDataSourceImpl(
  appDatabase: AppDatabase(),
    );
    final repository = DestinationRepositoryImpl(
      localDataSource: localDataSource,
    );
    _getDestinations = GetDestinations(repository);

    _loadDestinations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDestinations() async {
    try {
      final result = await _getDestinations();
      setState(() {
        _destinations = result;
        _filteredDestinations = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocurrió un error al cargar los destinos.';
        _isLoading = false;
      });
    }
  }

  void _filterDestinations(String query) {
    final normalizedQuery = query.toLowerCase().trim();

    setState(() {
      if (normalizedQuery.isEmpty) {
        _filteredDestinations = _destinations;
        return;
      }

      _filteredDestinations = _destinations.where((destination) {
        return destination.name.toLowerCase().contains(normalizedQuery) ||
            destination.category.toLowerCase().contains(normalizedQuery) ||
            destination.locationName.toLowerCase().contains(normalizedQuery);
      }).toList();
    });
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: _filterDestinations,
            decoration: InputDecoration(
              hintText: 'Buscar destino, categoría o ubicación',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredDestinations.isEmpty
              ? const Center(
                  child: Text('No se encontraron destinos.'),
                )
              : ListView.separated(
                  itemCount: _filteredDestinations.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final destination = _filteredDestinations[index];

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(destination.name.substring(0, 1)),
                      ),
                      title: Text(destination.name),
                      subtitle: Text(
                        '${destination.category} • ${destination.locationName}',
                      ),
                      trailing:
                          const Icon(Icons.arrow_forward_ios, size: 16),
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
                ),
        ),
      ],
    );
  }
}