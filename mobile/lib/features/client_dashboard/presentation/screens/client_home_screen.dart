import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/core/widgets/profile_avatar.dart';
import 'package:mobile/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:mobile/features/categories/domain/models/category.dart';
import 'package:mobile/features/categories/domain/services/category_service.dart';
import 'package:mobile/features/categories/presentation/screens/sub_category_screen.dart';
import 'package:mobile/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:mobile/features/client_dashboard/presentation/widgets/discount_card.dart';
import 'package:mobile/features/location/domain/providers/location_provider.dart';
import 'package:mobile/features/location/domain/services/location_service.dart';
import 'package:mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:mobile/features/providers/presentation/screens/provider_profile_screen.dart';
import 'package:mobile/features/search/domain/models/search_result.dart';
import 'package:mobile/features/search/domain/services/search_service.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({Key? key}) : super(key: key);

  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ClientHomeContent(),
    BookingsScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt),
            label: l10n.bookings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            label: l10n.chat,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: l10n.profile,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class ClientHomeContent extends ConsumerStatefulWidget {
  const ClientHomeContent({Key? key}) : super(key: key);

  @override
  _ClientHomeContentState createState() => _ClientHomeContentState();
}

class _ClientHomeContentState extends ConsumerState<ClientHomeContent> {
  final LocationService _locationService = LocationService();
  final CategoryService _categoryService = CategoryService();
  final SearchService _searchService = SearchService();

  List<Category> _categories = [];
  bool _isLoadingCategories = true;
  bool _showAllCategories = false;

  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      if (mounted) {
        ref.read(currentPositionProvider.notifier).state = position;
      }
    } catch (e) {
      log('Error getting location: $e');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await _categoryService.getCategories();
      if (mounted) {
        setState(() {
          _categories = fetchedCategories;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
      log('Error fetching categories: $e');
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        if (mounted) {
          setState(() {
            _searchResults.clear();
          });
        }
      }
    });
  }

  Future<void> _performSearch(String query) async {
    if (mounted) {
      setState(() {
        _isSearching = true;
      });
    }
    try {
      final results = await _searchService.getSuggestions(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
        });
      }
    } catch (e) {
      log('Error searching: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _handleSearchSelection(SearchResult result) {
    _searchController.clear();
    setState(() {
      _searchResults.clear();
    });

    if (result.type == 'provider') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProviderProfileScreen(providerId: result.id),
        ),
      );
    } else if (result.type == 'category') {
      final selectedCategory = _categories.firstWhere(
        (cat) => cat.id == result.id,
        orElse: () => Category(
            id: result.id, name: {'en': result.name, 'am': result.name}),
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SubCategoryScreen(category: selectedCategory)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userAsyncValue = ref.watch(userProvider);
    final currentPosition = ref.watch(currentPositionProvider);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: userAsyncValue.when(
          data: (user) {
            if (user == null) {
              return Center(
                  child: Text(l10n.userNotFoundRestart));
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: false,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        currentPosition != null
                            ? '${currentPosition.latitude.toStringAsFixed(2)}, ${currentPosition.longitude.toStringAsFixed(2)}'
                            : l10n.boleAddisAbaba,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {},
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: l10n.searchForServicesAndPackages,
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        if (_isSearching)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        else if (_searchResults.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.3),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                return ListTile(
                                  title: Text(result.name),
                                  subtitle: Text(result.type),
                                  onTap: () => _handleSearchSelection(result),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.cleaningServices,
                                  style:
                                      TextStyle(color: Colors.grey.shade600)),
                              const SizedBox(height: 8),
                              Text(l10n.qualityWorkAffordablePrice,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(l10n.weBringProfessionalCleaningServices,
                                  style:
                                      TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // You can replace this with an actual image
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
                _isLoadingCategories
                    ? const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()))
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildCategoryItem(
                                  context, _categories[index],
                                  bgColor: Colors.white,
                                  iconColor: Colors.black);
                            },
                            childCount: _categories.length,
                          ),
                        ),
                      ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text(l10n.errorLoadingProfile)),
        ));
  }

  Color _getCategoryBgColor(int index) {
    final colors = [
      const Color(0xFFE0EFFF),
      const Color(0xFFD4FFEE),
      const Color(0xFFFFF7ED),
      const Color(0xFFFFF1F2),
    ];
    return colors[index % colors.length];
  }

  Color _getCategoryIconColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];
    return colors[index % colors.length];
  }

  Widget _buildCategoryItem(
      BuildContext context, Category category,
      {required Color bgColor, required Color iconColor}) {
    IconData getIconData(String? iconName) {
      switch (iconName) {
        case 'plumbing':
          return Icons.plumbing;
        case 'bolt':
          return Icons.bolt;
        case 'cleaning_services':
          return Icons.cleaning_services;
        case 'home_repair_service':
          return Icons.home_repair_service;
        case 'devices':
          return Icons.devices;
        case 'format_paint':
          return Icons.format_paint;
        case 'architecture':
          return Icons.architecture;
        case 'satellite_alt':
          return Icons.satellite_alt;
        case 'construction':
          return Icons.construction;
        case 'electrical_services':
          return Icons.electrical_services;
        case 'power':
          return Icons.power;
        case 'roofing':
          return Icons.roofing;
        default:
          return Icons.category;
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryScreen(category: category),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              getIconData(category.icon),
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name[Localizations.localeOf(context).languageCode] ?? category.name['en']!,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
