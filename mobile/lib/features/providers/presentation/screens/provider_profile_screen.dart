import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/config.dart';
import 'package:mobile/features/location/domain/providers/location_provider.dart';
import 'package:mobile/features/providers/domain/models/provider.dart' as prov_model;
import 'package:mobile/features/providers/domain/services/provider_service.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/features/bookings/presentation/screens/confirm_booking_screen.dart';

class ProviderProfileScreen extends ConsumerStatefulWidget {
  final String providerId;
  final String? serviceName;

  const ProviderProfileScreen(
      {Key? key, required this.providerId, this.serviceName})
      : super(key: key);

  @override
  _ProviderProfileScreenState createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends ConsumerState<ProviderProfileScreen> {
  final ProviderService _providerService = ProviderService();
  prov_model.Provider? _provider;
  bool _isLoading = true;
  String? _selectedServiceId;

  final _descriptionController = TextEditingController();
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _fetchProvider();
  }

  Future<void> _fetchProvider() async {
    try {
      final fetchedProvider =
          await _providerService.getProvider(widget.providerId);
      if (mounted) {
        setState(() {
          _provider = fetchedProvider;
          _isLoading = false;
          if (fetchedProvider.serviceCategories.isNotEmpty) {
            final initialService = fetchedProvider.serviceCategories.firstWhere(
              (service) => service.category.name['en'] == widget.serviceName,
              orElse: () => fetchedProvider.serviceCategories.first,
            );
            _selectedServiceId = initialService.category.id;
          }
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
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              onPrimary: theme.colorScheme.onPrimary, 
              surface: theme.colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    
    final profilePhotoUrl = _provider?.user.profilePhoto;
    final fullImageUrl = (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty)
        ? (profilePhotoUrl.startsWith('http') ? profilePhotoUrl : '$baseUrl$profilePhotoUrl')
        : null;

    final providerName = _provider != null
        ? '${_provider!.user.firstName} ${_provider!.user.lastName}'
        : 'Loading...';
    
    final providerRole = _provider?.user.role ?? '';


    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  floating: false,
                  backgroundColor: theme.colorScheme.primary,
                  iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
                  flexibleSpace: FlexibleSpaceBar(
                    background: fullImageUrl != null 
                        ? Image.network(
                            fullImageUrl,
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.4),
                            colorBlendMode: BlendMode.darken,
                          )
                        : Container(color: theme.colorScheme.tertiary),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          providerName,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                         Text(
                          providerRole,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 24),
                        Text(
                          l10n.services,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        if (_provider != null && _provider!.serviceCategories.isNotEmpty)
                          DropdownButtonFormField<String>(
                            value: _selectedServiceId,
                            items: _provider!.serviceCategories
                                .map((service) => DropdownMenuItem(
                                      value: service.category.id,
                                      child: Text(service.category.name[locale] ?? service.category.name['en']!),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedServiceId = value;
                              });
                            },
                          ),

                        const SizedBox(height: 24),
                        Text(
                          l10n.describeYourIssue,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: l10n.enterDetailedDescription,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          l10n.preferredDates,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.onSurface,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: theme.colorScheme.tertiary)
                          ),
                          onPressed: () => _selectDateRange(context),
                          icon: const Icon(Icons.calendar_today, size: 20),
                          label: Text(_selectedDateRange == null
                              ? l10n.selectADateRange
                              : "${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.colorScheme.tertiary.withOpacity(0.5)))
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_provider != null &&
                _descriptionController.text.isNotEmpty &&
                _selectedDateRange != null &&
                _selectedServiceId != null) {
              
              final selectedService = _provider!.serviceCategories.firstWhere((service) => service.category.id == _selectedServiceId);
              final currentPosition = ref.read(currentPositionProvider);

              final jobDetails = {
                'providerId': widget.providerId,
                'providerName': providerName,
                'profilePhoto': _provider!.user.profilePhoto,
                'description': _descriptionController.text,
                'startDate': _selectedDateRange!.start.toIso8601String(),
                'endDate': _selectedDateRange!.end.toIso8601String(),
                'serviceName': selectedService.category.name[locale] ?? selectedService.category.name['en']!,
                if (currentPosition != null)
                  'location': {
                    'lat': currentPosition.latitude,
                    'lng': currentPosition.longitude
                  },
              };
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ConfirmBookingScreen(jobDetails: jobDetails),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                    content: Text(l10n.pleaseFillAllFields)),
              );
            }
          },
          child: Text(l10n.bookNow),
        ),
      ),
    );
  }
}
