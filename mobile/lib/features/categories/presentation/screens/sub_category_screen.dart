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
      return true;
    }
    if (childrenStates.every((state) => state == false)) {
      return false;
    }
    return null;
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
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: Text(categoryName),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        color: theme.colorScheme.surface,
        child: ElevatedButton(
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
          child: Text(l10n.viewProviders),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(Category category, {int depth = 0}) {
    final locale = Localizations.localeOf(context).languageCode;
    final title = category.name[locale] ?? category.name['en']!;
    final theme = Theme.of(context);
    
    if (category.subCategories.isEmpty) {
      return Material(
        color: theme.colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.only(left: 16.0 * depth),
          child: CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
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

    return Material(
       color: theme.colorScheme.surface,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.only(left: 24 + (16.0 * depth), right: 24),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
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
      ),
    );
  }
}
