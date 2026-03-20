import 'package:flutter/material.dart';
import 'destination_detail_page.dart';

import '../../data/datasources/local/app_database.dart';
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

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'playa':
        return Colors.blue;
      case 'cultural':
        return Colors.deepPurple;
      case 'naturaleza':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'playa':
        return Icons.beach_access;
      case 'cultural':
        return Icons.account_balance;
      case 'naturaleza':
        return Icons.park;
      default:
        return Icons.place;
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
              : ListView.builder(
                  itemCount: _filteredDestinations.length,
                  itemBuilder: (context, index) {
                    final destination = _filteredDestinations[index];
                    final categoryColor =
                        _getCategoryColor(destination.category);
                    final categoryIcon =
                        _getCategoryIcon(destination.category);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
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
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    destination.imageUrl,
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        width: 72,
                                        height: 72,
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        destination.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              destination.locationName,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Chip(
                                        visualDensity:
                                            VisualDensity.compact,
                                        label: Text(
                                          destination.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        avatar: Icon(
                                          categoryIcon,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: categoryColor,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}