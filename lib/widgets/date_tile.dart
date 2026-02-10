import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTile extends StatelessWidget {
  final String title;
  final DateTime? date;
  final VoidCallback onTap;

  const DateTile({
    super.key,
    required this.title,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            /// Date value
            Text(
              date == null
                  ? "Select date"
                  : DateFormat("dd MMM, EEE").format(date!),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                date == null ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
