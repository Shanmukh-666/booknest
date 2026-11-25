import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/categories/categories_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

const List<_NavItem> _kNavItems = [
  _NavItem(
    label: 'Home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
  ),
  _NavItem(
    label: 'Explore',
    icon: Icons.explore_outlined,
    activeIcon: Icons.explore_rounded,
  ),
  _NavItem(
    label: 'Categories',
    icon: Icons.category_outlined,
    activeIcon: Icons.category_rounded,
  ),
  _NavItem(
    label: 'Library',
    icon: Icons.bookmarks_outlined,
    activeIcon: Icons.bookmarks_rounded,
  ),
  _NavItem(
    label: 'Profile',
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
  ),
  _NavItem(
    label: 'Settings',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
  ),
];

/// Adaptive navigation shell for Desktop, Tablet, and Mobile viewports.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void _navigateTo(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  Widget _buildBody() {
    final pages = [
      HomeScreen(onNavigateTab: _navigateTo),
      const ExploreScreen(),
      const CategoriesScreen(),
      LibraryScreen(onBrowseCatalog: () => _navigateTo(1)),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(
        key: ValueKey<int>(_selectedIndex),
        child: pages[_selectedIndex],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    // Desktop (>= 1024px): Persistent Sidebar
    if (width >= 1024) {
      return Scaffold(
        body: Row(
          children: [
            Material(
              color: theme.colorScheme.surface,
              child: Container(
                width: 244,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: theme.colorScheme.outline),
                  ),
                ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 24, 20, 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accentAmber.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.local_library_rounded,
                            color: AppColors.accentAmber,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'BookNest',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.headline(context).copyWith(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _kNavItems.length,
                      itemBuilder: (context, index) {
                        final item = _kNavItems[index];
                        final selected = _selectedIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: ListTile(
                            selected: selected,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            selectedTileColor:
                                theme.colorScheme.primary.withValues(alpha: 0.10),
                            leading: Icon(
                              selected ? item.activeIcon : item.icon,
                              color: selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            title: Text(
                              item.label,
                              style: TextStyle(
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                            onTap: () => _navigateTo(index),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                      ),
                      title: Text(
                        themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onTap: themeProvider.toggleTheme,
                    ),
                  ),
                ],
              ),
            ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      );
    }

    // Tablet (600px - 1023px): Compact NavigationRail
    if (width >= 600) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _navigateTo,
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accentAmber.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.local_library_rounded,
                    color: AppColors.accentAmber,
                    size: 22,
                  ),
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: IconButton(
                      tooltip: 'Toggle Theme',
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                      ),
                      onPressed: themeProvider.toggleTheme,
                    ),
                  ),
                ),
              ),
              destinations: _kNavItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.activeIcon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: _buildBody()),
          ],
        ),
      );
    }

    // Mobile (< 600px): Compact AppBar + BottomNavigationBar (5 primary tabs + Settings shortcut in AppBar)
    final mobileItems = _kNavItems.take(5).toList();
    final bottomIndex = _selectedIndex < 5 ? _selectedIndex : 4;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.local_library_rounded,
              color: AppColors.accentAmber,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'BookNest',
              style: AppTextStyles.headline(context).copyWith(fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          IconButton(
            tooltip: 'Settings',
            icon: Icon(
              _selectedIndex == 5
                  ? Icons.settings_rounded
                  : Icons.settings_outlined,
            ),
            onPressed: () => _navigateTo(5),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomIndex,
        onDestinationSelected: _navigateTo,
        destinations: mobileItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.activeIcon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
