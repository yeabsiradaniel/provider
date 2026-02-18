import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobile/features/provider_profile/domain/models/availability.dart';
import 'package:mobile/features/provider_profile/domain/services/availability_service.dart';
import 'package:mobile/l10n/app_localizations.dart';

class AvailabilitySettingsScreen extends StatefulWidget {
  const AvailabilitySettingsScreen({Key? key}) : super(key: key);

  @override
  _AvailabilitySettingsScreenState createState() =>
      _AvailabilitySettingsScreenState();
}

class _AvailabilitySettingsScreenState
    extends State<AvailabilitySettingsScreen> {
  final AvailabilityService _availabilityService = AvailabilityService();
  Map<String, DayAvailability> _availability = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAvailability();
  }

  Future<void> _fetchAvailability() async {
    try {
      final availability = await _availabilityService.getAvailability();
      setState(() {
        _availability = availability;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAvailability() async {
    try {
      log('Saving availability: $_availability');
      await _availabilityService.updateAvailability(_availability);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Availability updated successfully!')),
      );
    } catch (e) {
      log('Error saving availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update availability.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.availabilitySettings),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAvailability,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                final day = _getDayName(index, l10n);
                final dayAvailability =
                    _availability[day.toLowerCase()] ?? DayAvailability(isAvailable: false);
                return SwitchListTile(
                  title: Text(day),
                  value: dayAvailability.isAvailable,
                  onChanged: (bool value) {
                    setState(() {
                      _availability[day.toLowerCase()] =
                          dayAvailability.copyWith(isAvailable: value);
                    });
                  },
                );
              },
            ),
    );
  }

  String _getDayName(int index, AppLocalizations l10n) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return '';
    }
  }
}
