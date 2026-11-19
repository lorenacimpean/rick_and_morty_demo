import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/ui/shared/components/lists/app_list_tile.dart';

typedef InfoRow = ({IconData icon, String label, String value});

// A card of facts, one row each: icon, value, and what the value is.
class InfoCard extends StatelessWidget {
  final List<InfoRow> rows;

  const InfoCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.primary;
    return Card(
      child: Column(
        children: [
          for (final row in rows)
            AppListTile(
              leading: Icon(row.icon, color: iconColor),
              title: row.value,
              subtitle: row.label,
            ),
        ],
      ),
    );
  }
}
