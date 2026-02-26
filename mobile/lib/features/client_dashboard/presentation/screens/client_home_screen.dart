import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:mobile/features/categories/domain/models/category.dart';
import 'package:mobile/features/categories/domain/services/category_service.dart';
import 'package:mobile/features/categories/presentation/screens/sub_category_screen.dart';
import 'package:mobile/features/chat/presentation/screens/chat_list_screen.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt_outlined),
            activeIcon: const Icon(Icons.list_alt),
            label: l10n.bookings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
             activeIcon: const Icon(Icons.chat_bubble),
            label: l10n.chat,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.secondary,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surface,
        elevation: 8,
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
    if(mounted) {
      setState(() {
        _searchResults.clear();
      });
    }

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
    final theme = Theme.of(context);

    return Scaffold(
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
                  title: Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        currentPosition != null
                            ? '${currentPosition.latitude.toStringAsFixed(2)}, ${currentPosition.longitude.toStringAsFixed(2)}'
                            : l10n.boleAddisAbaba,
                        style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
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
                            prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface),
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
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.5))
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
                                  subtitle: Text(result.type, style: TextStyle(color: theme.colorScheme.secondary)),
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
                      color: theme.colorScheme.surface,
                      border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.5))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.cleaningServices,
                                  style:
                                      TextStyle(color: theme.colorScheme.secondary)),
                              const SizedBox(height: 8),
                              Text(l10n.qualityWorkAffordablePrice,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(l10n.weBringProfessionalCleaningServices,
                                  style:
                                      TextStyle(color: theme.colorScheme.secondary)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 100,
                          height: 100,
                          color: theme.colorScheme.tertiary,
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
                                  context, _categories[index]);
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

  Widget _buildCategoryItem(BuildContext context, Category category) {
     final theme = Theme.of(context);
    IconData getIconData(String? iconName) {
      switch (iconName) {
        case 'plumbing': return Icons.plumbing;
        case 'bolt': return Icons.bolt;
        case 'cleaning_services': return Icons.cleaning_services;
        case 'home_repair_service': return Icons.home_repair_service;
        case 'devices': return Icons.devices;
        case 'format_paint': return Icons.format_paint;
        case 'architecture': return Icons.architecture;
        case 'satellite_alt': return Icons.satellite_alt;
        case 'construction': return Icons.construction;
        case 'electrical_services': return Icons.electrical_services;
        case 'power': return Icons.power;
        case 'roofing': return Icons.roofing;
        default: return Icons.category;
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
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.5))
            ),
            child: Icon(
              getIconData(category.icon),
              size: 40,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name[Localizations.localeOf(context).languageCode] ?? category.name['en']!,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
