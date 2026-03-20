import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/destination.dart';

class DestinationDetailPage extends StatefulWidget {
  final Destination destination;

  const DestinationDetailPage({
    super.key,
    required this.destination,
  });

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  bool _hasInternet = true;
  bool _isCheckingConnection = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();

    final hasConnection = result.any(
      (connection) => connection != ConnectivityResult.none,
    );

    if (!mounted) return;

    setState(() {
      _hasInternet = hasConnection;
      _isCheckingConnection = false;
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
    final destination = widget.destination;
    final categoryColor = _getCategoryColor(destination.category);
    final categoryIcon = _getCategoryIcon(destination.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(destination.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 190,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Image.asset(
                  destination.imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.red.shade100,
                      alignment: Alignment.center,
                      child: Text(
                        'No se pudo cargar:\n${destination.imageUrl}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Chip(
                    label: Text(
                      destination.category,
                      style: const TextStyle(color: Colors.white),
                    ),
                    avatar: Icon(
                      categoryIcon,
                      size: 18,
                      color: Colors.white,
                    ),
                    backgroundColor: categoryColor,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          destination.locationName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    destination.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ubicación',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _isCheckingConnection
                      ? _buildLoadingMap()
                      : _hasInternet
                          ? _buildOnlineMap(destination)
                          : _buildOfflineMap(destination),
                  const SizedBox(height: 8),
                  Text(
                    _hasInternet
                        ? 'Mapa interactivo cargado con conexión.'
                        : 'Sin conexión: se muestra una referencia local de la ubicación.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (!_hasInternet) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Podés acercar o mover la imagen del mapa.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    'Latitud: ${destination.latitude} | Longitud: ${destination.longitude}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingMap() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildOnlineMap(Destination destination) {
    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
              destination.latitude,
              destination.longitude,
            ),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.fama_app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    destination.latitude,
                    destination.longitude,
                  ),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineMap(Destination destination) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey.shade200,
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            boundaryMargin: const EdgeInsets.all(20),
            panEnabled: true,
            scaleEnabled: true,
            child: Center(
              child: Image.asset(
                destination.mapImageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: Text(
                      'No se pudo cargar el mapa offline:\n${destination.mapImageUrl}',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}