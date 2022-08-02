import 'package:carex_flutter/ui/widgets/drawer.dart';
import 'package:carex_flutter/ui/widgets/settings_provider.dart';
import 'package:carex_flutter/util/constants/list_constants.dart';
import 'package:carex_flutter/util/constants/ui_constants.dart';
import 'package:carex_flutter/util/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const id = "/settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? currency;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final _currency = SettingsProvider.get(context).getCurrency();
      setState(() {
        currency = _currency;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      drawer: const CarexDrawer(
        currentRoute: SettingsScreen.id,
      ),
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffdedede),
                      borderRadius: InterfaceUtil.allBorderRadius9,
                    ),
                    padding: const EdgeInsets.all(9),
                    child: Icon(
                      Iconsax.dollar_square4,
                      size: 28,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Currency"),
                        Text(
                          "Currency that will show in the app",
                          style: theme.textTheme.displaySmall?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  DropdownButton<String>(
                    value: currency,
                    underline: Container(),
                    borderRadius: InterfaceUtil.allBorderRadius16,
                    items: List<DropdownMenuItem<String>>.of(
                      currencies.map(
                        (e) => DropdownMenuItem(
                          value: e.split("|").last.trim(),
                          child: Text(e),
                        ),
                      ),
                    ),
                    onChanged: (item) async => handleCurrencyChange(item),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  handleCurrencyChange(String? item) async {
    if (item != null && item.isNotEmpty) {
      final updated = await SettingsProvider.get(context).updateCurrency(item);

      if (updated) {
        SnackBarUtil.showInfoSnackBar(context, "Currency updated to $item");
        setState(() {
          currency = item;
        });
      }
    }
  }
}
