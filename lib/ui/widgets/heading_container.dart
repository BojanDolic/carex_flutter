import 'package:flutter/material.dart';

class HeadingContainer extends StatelessWidget {
  const HeadingContainer({
    Key? key,
    this.headText,
    this.children,
  }) : super(key: key);
  final String? headText;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      children: [
        Visibility(
          visible: headText != null,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 36),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 12,
                  right: 24,
                  bottom: 3,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(36),
                    topLeft: Radius.circular(16),
                  ),
                ),
                child: Text(
                  headText ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.displayMedium,
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children ?? [],
          ),
        ),
      ],
    );
  }
}
