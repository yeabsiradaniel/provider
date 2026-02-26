import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/core/config.dart';
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
      if (mounted) {
        setState(() {
          _providers = fetchedProviders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              l10n.availableProviders,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Implement filter functionality
                },
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : _providers.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          l10n.noProvidersFound,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final provider = _providers[index];
                            return _buildProviderItem(context, provider);
                          },
                          childCount: _providers.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildProviderItem(BuildContext context, Provider provider) {
    final name = '${provider.user.firstName} ${provider.user.lastName}';
    final rating = provider.user.rating ?? 0.0;
    final photoPath = provider.user.profilePhoto;
    final price = provider.serviceCategories.isNotEmpty
        ? provider.serviceCategories.first.price
        : null;
    final role = provider.user.role;
    final status = provider.isOnline;

    ImageProvider? backgroundImage;
    if (photoPath != null && photoPath.isNotEmpty) {
      backgroundImage = NetworkImage('$baseUrl$photoPath');
    }

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
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    image: backgroundImage != null
                        ? DecorationImage(
                            image: backgroundImage, fit: BoxFit.cover)
                        : null,
                  ),
                  child: backgroundImage == null
                      ? const Icon(Icons.person, color: Colors.grey, size: 50)
                      : null,
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share,
                        color: Colors.white, size: 14),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        role,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                      const Icon(Icons.more_vert, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          status ? Colors.black : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status ? 'ONLINE' : 'OFFLINE',
                      style: TextStyle(
                        color: status ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (price != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$price ETB/hrs',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
