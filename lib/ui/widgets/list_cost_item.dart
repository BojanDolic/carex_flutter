import 'package:carex_flutter/services/models/cost.dart';
import 'package:carex_flutter/ui/widgets/settings_provider.dart';
import 'package:carex_flutter/util/constants/ui_constants.dart';
import 'package:carex_flutter/util/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ListCostItem extends StatelessWidget {
  const ListCostItem({
    Key? key,
    required this.cost,
    required this.onTap,
    required this.onDismiss,
    this.padding,
  }) : super(key: key);

  final Cost cost;
  final Function()? onTap;
  final Function(DismissDirection)? onDismiss;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = SettingsProvider.get(context);
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 3,
          ),
      child: Material(
        shape: InterfaceUtil.allCornerRadiusRoundedRectangle16,
        color: Colors.white,
        child: Dismissible(
          key: UniqueKey(),
          background: Container(
            decoration: const BoxDecoration(
              borderRadius: InterfaceUtil.allBorderRadius16,
              color: Colors.red,
            ),
            child: const Icon(
              Iconsax.note_remove,
              color: Colors.white,
            ),
          ),
          onDismissed: onDismiss,
          child: ListTile(
            leading: WidgetUtil.getIconBasedOnCostType(cost.category),
            title: Text(cost.description),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ${cost.totalPrice} ${settings.getCurrency()}",
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  DateFormat("dd MMMM").format(
                    DateTime.parse(cost.date),
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.displaySmall?.copyWith(),
                ),
              ],
            ),
            onTap: onTap,
            //tileColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            shape: InterfaceUtil.allCornerRadiusRoundedRectangle16,
          ),
        ),
      ),
    );
  }
}
