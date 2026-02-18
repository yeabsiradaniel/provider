import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/features/location/domain/services/location_service.dart';
import 'package:mobile/features/providers/domain/models/provider.dart';
import 'package:mobile/features/providers/domain/services/provider_service.dart';
import 'package:mobile/features/providers/presentation/screens/provider_profile_screen.dart';
import 'package:mobile/features/providers/presentation/widgets/provider_card.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ProviderListScreen extends StatefulWidget {
  final List<String> categoryIds;

  const ProviderListScreen({Key? key, required this.categoryIds})
      : super(key: key);

  @override
  _ProviderListScreenState createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  final ProviderService _providerService = ProviderService();
  final LocationService _locationService = LocationService();
  List<Provider> _providers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProviders();
  }

  Future<void> _fetchProviders() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final fetchedProviders = await _providerService.searchProviders(
        widget.categoryIds,
        position,
      );
      setState(() {
        _providers = fetchedProviders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.availableProviders),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement filter functionality
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _providers.isEmpty
              ? Center(child: Text(l10n.noProvidersFound))
              : ListView.builder(
                  itemCount: _providers.length,
                  itemBuilder: (context, index) {
                    final provider = _providers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProviderProfileScreen(
                              providerId: provider.user.id,
                            ),
                          ),
                        );
                      },
                      child: ProviderCard(
                        name:
                            '${provider.user.firstName} ${provider.user.lastName}',
                        distance: provider.distance,
                        rating: provider.user.rating ?? 0.0,
                        price: provider.serviceCategories.isNotEmpty 
                                ? provider.serviceCategories.first.price 
                                : null,
                        status: provider.isOnline ? 'ONLINE' : 'OFFLINE',
                        imageUrl: provider.user.profilePhoto ?? '',
                      ),
                    );
                  },
                ),
    );
  }
}
