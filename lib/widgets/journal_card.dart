import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/journal.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';

class JournalCard extends StatelessWidget {
  final Journal journal;
  final VoidCallback onTap;

  const JournalCard({super.key, required this.journal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: _buildImage(),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journal.title,
                    style: AppTextStyles.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDate(journal.travelDate),
                        style: AppTextStyles.bodySmall,
                      ),
                      if (journal.location.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            journal.location,
                            style: AppTextStyles.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (journal.story.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      journal.story,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (journal.imagePath == null || journal.imagePath!.isEmpty) {
      return Container(
        height: 160,
        color: AppColors.primary.withOpacity(0.08),
        child: Center(
          child: Icon(
            Icons.landscape_outlined,
            size: 48,
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
      );
    }

    if (kIsWeb) {
      return Image.network(
        journal.imagePath!,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 160,
          color: AppColors.primary.withOpacity(0.08),
          child: const Icon(Icons.broken_image, color: AppColors.textMuted),
        ),
      );
    }

    return Image.file(
      File(journal.imagePath!),
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 160,
        color: AppColors.primary.withOpacity(0.08),
        child: const Icon(Icons.broken_image, color: AppColors.textMuted),
      ),
    );
  }
}
