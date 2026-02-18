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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: userAsyncValue.when(
                  data: (user) {
                    if (user == null) {
                      return const Center(
                          child:
                              Text('User not found. Please restart the app.'));
                    }
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ProfileAvatar(
                                  imageUrl: user.profilePhoto ?? '',
                                  radius: 20,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 14,
                                            color: Theme.of(context).textTheme.bodySmall?.color),
                                        const SizedBox(width: 4),
                                        Text(
                                          currentPosition != null
                                              ? '${currentPosition.latitude.toStringAsFixed(2)}, ${currentPosition.longitude.toStringAsFixed(2)}'
                                              : l10n.boleAddisAbaba,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      l10n.helloUser(user.firstName),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.notifications,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Column(
                          children: [
                            TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              onSubmitted: _performSearch,
                              decoration: InputDecoration(
                                hintText: l10n.searchForExperts,
                                prefixIcon: const Icon(Icons.search),
                                prefixIconColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                                filled: true,
                                fillColor: Theme.of(context)
                                    .scaffoldBackgroundColor,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
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
                                margin:
                                    const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius:
                                      BorderRadius.circular(16),
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
                                        MediaQuery.of(context).size.height *
                                            0.3),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _searchResults.length,
                                  itemBuilder: (context, index) {
                                    final result =
                                        _searchResults[index];
                                    return ListTile(
                                      title: Text(result.name),
                                      subtitle: Text(result.type),
                                      onTap: () =>
                                          _handleSearchSelection(result),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      const Center(child: Text('Error loading profile.')),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.categories,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showAllCategories = !_showAllCategories;
                            });
                          },
                          child: Text(
                            _showAllCategories ? "See Less" : l10n.seeAll,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _isLoadingCategories
                        ? const Center(child: CircularProgressIndicator())
                        : AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Column(
                              children: [
                                for (int i = 0;
                                    i <
                                        (_showAllCategories
                                            ? _categories.length
                                            : (_categories.length > 4
                                                ? 4
                                                : _categories.length));
                                    i += 4)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        for (int j = i;
                                            j < i + 4 &&
                                                j < _categories.length;
                                            j++)
                                          _buildCategoryItem(
                                            context,
                                            _categories[j],
                                            bgColor: _getCategoryBgColor(j),
                                            iconColor:
                                                _getCategoryIconColor(j),
                                          ),
                                        for (int k = 0;
                                            k <
                                                (4 -
                                                    (_categories.length - i)
                                                        .clamp(0, 4));
                                            k++)
                                          const SizedBox(width: 64),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: DiscountCard(
                        color: const Color(0xFF1E293B),
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.discountOff(200),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${l10n.on} ${l10n.electricians}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.limitedTime.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF94A3B8),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                getIconData(category.icon),
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name[Localizations.localeOf(context).languageCode] ?? category.name['en']!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
