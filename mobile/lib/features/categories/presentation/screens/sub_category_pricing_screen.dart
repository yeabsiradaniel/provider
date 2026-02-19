import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/screens/auth_check_screen.dart';
import 'package:mobile/features/categories/domain/models/category.dart';
import 'package:mobile/features/provider_dashboard/domain/services/provider_service.dart';

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
  final Map<String, TextEditingController> _priceControllers = {};
  bool _isSaving = false;
  final ProviderService _providerService = ProviderService();

  @override
  void initState() {
    super.initState();
    for (var category in widget.categories) {
      _priceControllers[category.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _priceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _savePrices() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final List<Map<String, dynamic>> services = [];
      for (var category in widget.categories) {
        final price = int.tryParse(_priceControllers[category.id]!.text);
        if (price != null) {
          services.add({
            'category': category.id,
            'price': price,
          });
        }
      }

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving prices: $e')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Prices'),
      ),
      body: ListView.builder(
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(category.name['en'] ?? 'No name'),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _priceControllers[category.id],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _savePrices,
          child: _isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Save and Finish'),
        ),
      ),
    );
  }
}
