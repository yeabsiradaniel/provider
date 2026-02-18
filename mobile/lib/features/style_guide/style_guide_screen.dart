import 'package:flutter/material.dart' hide SearchBar;
import 'package:mobile/core/widgets/asym_button.dart';
import 'package:mobile/core/widgets/asym_card.dart';
import 'package:mobile/core/widgets/language_card.dart';
import 'package:mobile/core/widgets/segmented_tab.dart';
import 'package:mobile/core/widgets/labeled_text_field.dart';
import 'package:mobile/core/widgets/search_bar.dart';
import 'package:mobile/core/widgets/category_icon.dart';
import 'package:mobile/core/widgets/provider_list_item.dart';
import 'package:mobile/core/widgets/app_bottom_nav_bar.dart';

class StyleGuideScreen extends StatefulWidget {
  const StyleGuideScreen({super.key});

  @override
  State<StyleGuideScreen> createState() => _StyleGuideScreenState();
}

class _StyleGuideScreenState extends State<StyleGuideScreen> {
  int _selectedSegment = 0;
  int _selectedNavBarItem = 0;
  final TextEditingController _phoneController = TextEditingController(text: '911 000 000');
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Component Style Guide'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Asymmetric Button', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              AsymButton(
                onPressed: () {},
                label: 'CONTINUE',
              ),
              const SizedBox(height: 32),
              const Text('Asymmetric Card', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              AsymCard(
                color: Colors.blue.shade50,
                borderColor: Theme.of(context).colorScheme.primary,
                borderWidth: 2,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Asymmetric Card Title', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('This is an example of an asymmetric card.', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text('Language Card', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              LanguageCard(
                title: 'አማርኛ',
                subtitle: 'Default',
                isSelected: true,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              LanguageCard(
                title: 'English',
                subtitle: 'Supported',
                isSelected: false,
                onTap: () {},
              ),
              const SizedBox(height: 32),
              const Text('Segmented Tab', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SegmentedTab(
                options: const ['Customer', 'Provider'],
                selectedIndex: _selectedSegment,
                onSegmentSelected: (index) {
                  setState(() {
                    _selectedSegment = index;
                  });
                },
              ),
              const SizedBox(height: 32),
              const Text('Labeled Text Field', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              LabeledTextField(
                label: 'Phone',
                prefixText: '+251',
                controller: _phoneController,
                readOnly: true,
              ),
              const SizedBox(height: 32),
              const Text('Search Bar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SearchBar(
                controller: _searchController,
                hintText: 'Search for experts...',
              ),
              const SizedBox(height: 32),
              const Text('Category Icon', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  CategoryIcon(
                    icon: Icons.bolt,
                    label: 'Electric',
                    backgroundColor: Colors.blue.shade50,
                    iconColor: Theme.of(context).colorScheme.primary,
                  ),
                  CategoryIcon(
                    icon: Icons.plumbing,
                    label: 'Plumbing',
                    backgroundColor: Colors.green.shade50,
                    iconColor: Colors.green.shade600,
                  ),
                  CategoryIcon(
                    icon: Icons.cleaning_services,
                    label: 'Cleaning',
                    backgroundColor: Colors.orange.shade50,
                    iconColor: Colors.orange.shade500,
                  ),
                  CategoryIcon(
                    icon: Icons.home_repair_service,
                    label: 'Repair',
                    backgroundColor: Colors.red.shade50,
                    iconColor: Colors.red.shade500,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Provider List Item', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ProviderListItem(
                imageUrl: 'https://via.placeholder.com/64x80',
                providerName: 'Abebe Kebede',
                rating: 4.9,
                location: 'Kazanchis',
                distance: '1.2km away',
                price: 350,
                priceUnit: 'hr',
                status: 'VERIFIED',
              ),
              const SizedBox(height: 16),
              ProviderListItem(
                imageUrl: 'https://via.placeholder.com/64x80',
                providerName: 'Mulugeta T.',
                rating: 4.7,
                location: 'Bole',
                distance: '2.5km away',
                price: 280,
                priceUnit: 'hr',
                status: 'OFFLINE',
              ),
              const SizedBox(height: 100), // Add extra space at the bottom to avoid overlap with nav bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedNavBarItem,
        onTap: (index) {
          setState(() {
            _selectedNavBarItem = index;
          });
        },
      ),
    );
  }
}
