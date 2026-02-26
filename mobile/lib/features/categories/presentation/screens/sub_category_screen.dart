import 'package:flutter/material.dart';
import 'package:mobile/features/categories/domain/models/category.dart';
import 'package:mobile/features/providers/presentation/screens/provider_list_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';

class SubCategoryScreen extends StatefulWidget {
  final Category category;

  const SubCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  Set<String> _selectedCategoryIds = {};

  @override
  void initState() {
    super.initState();
    // Pre-select the top-level category passed to the screen
    _onCategorySelected(widget.category, true);
  }

  void _onCategorySelected(Category category, bool? isSelected) {
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

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final categoryName = widget.category.name[locale] ?? widget.category.name['en']!;

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
              categoryName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final sub = widget.category.subCategories[index];
                return _buildCategoryTile(sub, depth: 0);
              },
              childCount: widget.category.subCategories.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              disabledForegroundColor: Colors.grey.shade400,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _selectedCategoryIds.isNotEmpty
                ? () {
                    final leafNodes = _getLeafNodes([widget.category], _selectedCategoryIds);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProviderListScreen(
                          categoryIds: leafNodes.toList(),
                        ),
                      ),
                    );
                  }
                : null,
            child: Text(
              l10n.viewProviders,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(Category category, {int depth = 0}) {
    final locale = Localizations.localeOf(context).languageCode;
    final title = category.name[locale] ?? category.name['en']!;
    
    if (category.subCategories.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: 16.0 * depth),
        child: Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.black,
          ),
          child: CheckboxListTile(
            activeColor: Colors.black,
            checkColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            value: _selectedCategoryIds.contains(category.id),
            onChanged: (bool? value) {
              _onCategorySelected(category, value);
            },
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        ),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.only(left: 24 + (16.0 * depth), right: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            activeColor: Colors.black,
            checkColor: Colors.white,
            value: _getCheckboxState(category),
            tristate: true,
            onChanged: (bool? value) {
              _onCategorySelected(category, value ?? false);
            },
          ),
        ),
        children: category.subCategories
            .map((sub) => _buildCategoryTile(sub, depth: depth + 1))
            .toList(),
      ),
    );
  }
}
