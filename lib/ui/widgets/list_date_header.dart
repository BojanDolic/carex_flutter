import 'package:carex_flutter/services/models/cost.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class DateHeaderWidget extends StatelessWidget {
  const DateHeaderWidget({
    Key? key,
    required this.cost,
    this.padding,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final Cost cost;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.only(
            top: 12,
            bottom: 9,
            left: 16,
            right: 16,
          ),
      child: Row(
        children: [
          const Icon(
            Iconsax.calendar_1,
          ),
          const SizedBox(
            width: 9,
          ),
          Text(
            DateFormat("MMMM yyyy").format(
              DateTime.parse(cost.date),
            ),
          ),
        ],
      ),
    );
  }
}
