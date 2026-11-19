import 'package:material_ui/material_ui.dart';

typedef AppTab = ({String label, IconData icon, IconData selectedIcon});

// Bottom navigation around the current tab's screen.
class AppShell extends StatelessWidget {
  final List<AppTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final Widget body;

  const AppShell({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTabSelected,
        destinations: [
          for (final tab in tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}
