import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/app_keys.dart';

typedef AppTab = ({
  Key? key,
  String label,
  IconData icon,
  IconData selectedIcon,
});

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
        key: AppKeys.shell.navigationBar,
        selectedIndex: currentIndex,
        onDestinationSelected: onTabSelected,
        destinations: [
          for (final tab in tabs)
            NavigationDestination(
              key: tab.key,
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}
