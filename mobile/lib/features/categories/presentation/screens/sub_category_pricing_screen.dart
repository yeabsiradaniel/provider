import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/screens/auth_check_screen.dart';
import 'package:mobile/features/categories/domain/models/category.dart';
import 'package:mobile/features/provider_dashboard/domain/services/provider_service.dart';
import 'package:mobile/l10n/app_localizations.dart';

class SubCategoryPricingScreen extends ConsumerStatefulWidget {
  final List<Category> categories;

  const SubCategoryPricingScreen({Key? key, required this.categories})
      : super(key: key);

  @override
  _SubCategoryPricingScreenState createState() =>
      _SubCategoryPricingScreenState();
}

class _SubCategoryPricingScreenState
    extends ConsumerState<SubCategoryPricingScreen> {
  final TextEditingController _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  final ProviderService _providerService = ProviderService();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _savePrices() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final price = int.tryParse(_priceController.text);
      if (price == null) {
        // This case should be caught by the validator, but as a safeguard:
        setState(() => _isSaving = false);
        return;
      }

      final List<Map<String, dynamic>> services = widget.categories.map((category) {
        return {
          'category': category.id,
          'price': price,
        };
      }).toList();

      await _providerService.updateServices(services);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthCheckScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      log('Error saving prices: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorSavingPrices}$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setYourPrices),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.setYourStandardRate,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.priceHelperText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.secondary),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _priceController,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: l10n.priceHint,
                    hintStyle: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary.withOpacity(0.3),
                    ),
                    border: InputBorder.none,
                    prefixText: l10n.currencyPrefix,
                    prefixStyle: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterPrice;
                    }
                    if (int.tryParse(value) == null) {
                      return l10n.pleaseEnterValidNumber;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _savePrices,
          child: _isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(l10n.saveAndFinish),
        ),
      ),
    );
  }
}
