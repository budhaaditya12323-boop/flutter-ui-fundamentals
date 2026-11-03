import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';
import 'tabs/course_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/favorite_tab.dart';

class MainShell extends StatefulWidget {
  final String nama;
  final String nim;

  const MainShell({
    super.key,
    required this.nama,
    required this.nim,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeTab(nama: widget.nama, nim: widget.nim),
      CoursesTab(nama: widget.nama, nim: widget.nim,),
      FavoritesPage(nama: widget.nama, nim: widget.nim),
      ProfileTab(nama: widget.nama, nim: widget.nim),
    ];

    return LayoutBuilder(                          
      builder: (context, constraints) {
        // ─── COMPACT / MEDIUM (< 840) ───
        if (constraints.maxWidth < 840) {
          return Scaffold(
            body: pages[_currentIndex],            // ← page yang sama
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              destinations: _destinations, 
            ),
          );
        }

        // ─── EXPANDED (>= 840) ───
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() => _currentIndex = index);
                },
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.school_outlined),
                    selectedIcon: Icon(Icons.school),
                    label: Text('Courses'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_border),
                    selectedIcon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: pages[_currentIndex]),   // ← page yang sama
            ],
          ),
        );
      },
    );
  }

  // ← destinations untuk NavigationBar
  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.school_outlined),
      selectedIcon: Icon(Icons.school),
      label: 'Courses',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_border),
      selectedIcon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];
}
