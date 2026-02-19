import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/categories/domain/models/category.dart';
import 'package:mobile/features/categories/domain/services/category_service.dart';
import 'package:mobile/features/provider_dashboard/domain/services/provider_service.dart';
import 'package:mobile/features/categories/presentation/screens/sub_category_pricing_screen.dart';
import 'package:mobile/features/provider_profile/domain/providers/provider_profile_provider.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

class CategorySelectionScreen extends ConsumerStatefulWidget {
  final Set<String>? initialSelectedCategoryIds;
  const CategorySelectionScreen({Key? key, this.initialSelectedCategoryIds})
      : super(key: key);

  @override
  _CategorySelectionScreenState createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends ConsumerState<CategorySelectionScreen> {
  final CategoryService _categoryService = CategoryService();
  final ProviderService _providerService = ProviderService();
  List<Category> _categories = [];
  Set<String> _selectedCategoryIds = {};
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedCategoryIds != null) {
      log('[CategorySelectionScreen] Received initial IDs: ${widget.initialSelectedCategoryIds}');
      _selectedCategoryIds = widget.initialSelectedCategoryIds!;
    }
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      log('Error fetching categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSelection() async {
    setState(() {
      _isSaving = true;
    });
    try {
      final user = ref.read(userProvider).value;
      if (user == null) return;
      
      final leafNodeIds = _getLeafNodes(_categories, _selectedCategoryIds);
      // We only want to save the leaf nodes
      await _providerService.updateCategories(leafNodeIds.toList());
      
      // After saving, refresh the provider profile to get the updated list
      await ref.read(providerProfileProvider(user.id).notifier).fetchProviderProfile();
      
      final leafNodeObjects = _getLeafCategoryObjects(_categories, _selectedCategoryIds);

      // Navigate to the next step: Pricing
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubCategoryPricingScreen(categories: leafNodeObjects),
          ),
        );
      }
    } catch (e) {
      log('Error saving categories: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  
  Set<String> _getLeafNodes(List<Category> categories, Set<String> selectedIds) {
    final leafNodes = <String>{};
    void traverse(Category category) {
      if (category.subCategories.isEmpty) {
        if (selectedIds.contains(category.id)) {
          leafNodes.add(category.id);
        }
      } else {
        for (var sub in category.subCategories) {
          traverse(sub);
        }
      }
    }
    for (var cat in categories) {
      traverse(cat);
    }
    return leafNodes;
  }

  List<Category> _getLeafCategoryObjects(List<Category> categories, Set<String> selectedIds) {
    final leafNodes = <Category>[];
    void traverse(Category category) {
      if (category.subCategories.isEmpty) {
        if (selectedIds.contains(category.id)) {
          leafNodes.add(category);
        }
      } else {
        for (var sub in category.subCategories) {
          traverse(sub);
        }
      }
    }
    for (var cat in categories) {
      traverse(cat);
    }
    return leafNodes;
  }

  void _navigateToDashboard() {
    Navigator.of(context).pop();
  }

  void _onCategorySelected(Category category, bool? isSelected) {
    log('[CategorySelectionScreen] _onCategorySelected: ${category.name['en']}, isSelected: $isSelected');
    setState(() {
      if (isSelected == true) {
        _selectAllChildren(category, true);
      } else {
        _selectAllChildren(category, false);
      }
    });
  }

  void _selectAllChildren(Category category, bool select) {
    if (select) {
      _selectedCategoryIds.add(category.id);
    } else {
      _selectedCategoryIds.remove(category.id);
    }
    for (var subCategory in category.subCategories) {
      _selectAllChildren(subCategory, select);
    }
  }

  bool? _getCheckboxState(Category category) {
    if (category.subCategories.isEmpty) {
      return _selectedCategoryIds.contains(category.id);
    }

    final childrenStates = category.subCategories.map(_getCheckboxState).toSet();

    if (childrenStates.every((state) => state == true)) {
      return true; // All children are selected
    }
    if (childrenStates.every((state) => state == false)) {
      return false; // No children are selected
    }
    return null; // Some children are selected (tristate)
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectYourServices),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateToDashboard,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryTile(_categories[index]);
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveSelection,
          child: _isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(l10n.save),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(Category category, {int depth = 0}) {
    final locale = Localizations.localeOf(context).languageCode;
    
    if (category.subCategories.isEmpty) {
      // Leaf node
      return Padding(
        padding: EdgeInsets.only(left: 16.0 * depth),
        child: CheckboxListTile(
          title: Text(category.name[locale] ?? category.name['en']!),
          value: _selectedCategoryIds.contains(category.id),
          onChanged: (bool? value) {
            _onCategorySelected(category, value);
          },
        ),
      );
    }

    // Parent node
    return Padding(
      padding: EdgeInsets.only(left: 16.0 * depth),
      child: ExpansionTile(
        title: Text(category.name[locale] ?? category.name['en']!),
        leading: Checkbox(
          value: _getCheckboxState(category),
          tristate: true,
          onChanged: (bool? value) {
            _onCategorySelected(category, value ?? false);
          },
        ),
        children: category.subCategories
            .map((sub) => _buildCategoryTile(sub, depth: depth + 1))
            .toList(),
      ),
    );
  }
}
