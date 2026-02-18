import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/categories/domain/models/category.dart';
import 'package:mobile/features/location/domain/providers/location_provider.dart';
import 'package:mobile/features/providers/domain/models/provider.dart' as prov_model;
import 'package:mobile/features/providers/domain/services/provider_service.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/features/bookings/presentation/screens/confirm_booking_screen.dart';
import 'dart:developer';

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
      setState(() {
        _provider = fetchedProvider;
        _isLoading = false;
        if (fetchedProvider.serviceCategories.isNotEmpty) {
          // If a serviceName was passed, try to select it, otherwise default to the first
          final initialService = fetchedProvider.serviceCategories.firstWhere(
            (service) => service.category.name['en'] == widget.serviceName,
            orElse: () => fetchedProvider.serviceCategories.first,
          );
          _selectedServiceId = initialService.category.id;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    final currentPosition = ref.watch(currentPositionProvider);
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      _provider?.user.profilePhoto ??
                          'https://via.placeholder.com/400',
                      fit: BoxFit.cover,
                    ),
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
                        // Provider details...
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                  _provider?.user.profilePhoto ??
                                      'https://via.placeholder.com/150'),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_provider?.user.firstName ?? ''} ${_provider?.user.lastName ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Provider", // This should be dynamic
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.call),
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Service Selection
                        Text(
                          l10n.services,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),

                        const SizedBox(height: 24),
                        // Issue Description
                        Text(
                          "Describe your issue",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                "Enter a description of the problem...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Date Range Selection
                        Text(
                          "Preferred Dates",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () => _selectDateRange(context),
                          icon: const Icon(Icons.calendar_today),
                          label: Text(_selectedDateRange == null
                              ? "Select a date range"
                              : "${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_provider != null &&
                _descriptionController.text.isNotEmpty &&
                _selectedDateRange != null &&
                _selectedServiceId != null) {
              
              final selectedService = _provider!.serviceCategories.firstWhere((service) => service.category.id == _selectedServiceId);

              final jobDetails = {
                'providerId': widget.providerId,
                'providerName':
                    '${_provider!.user.firstName} ${_provider!.user.lastName}',
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
              log("Navigating to ConfirmBooking with details: $jobDetails");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ConfirmBookingScreen(jobDetails: jobDetails),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please fill all fields before booking.')),
              );
            }
          },
          child: Text(l10n.bookNow),
        ),
      ),
    );
  }
}
