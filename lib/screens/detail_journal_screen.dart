import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';

class DetailJournalScreen extends StatelessWidget {
  final String journalId;

  const DetailJournalScreen({super.key, required this.journalId});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<JournalProvider>();
    final journal = provider.getJournalById(journalId);

    if (journal == null) {
      return const Scaffold(body: Center(child: Text('Journal not found')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero image app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/edit-journal',
                    arguments: journal.id,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => _showDeleteDialog(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroImage(journal.imagePath),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(journal.title, style: AppTextStyles.displayMedium),
                  const SizedBox(height: 12),

                  // Metadata row
                  Row(
                    children: [
                      _MetaChip(
                        icon: Icons.calendar_today_outlined,
                        label: DateFormatter.formatDate(journal.travelDate),
                      ),
                      const SizedBox(width: 8),
                      if (journal.location.isNotEmpty)
                        _MetaChip(
                          icon: Icons.location_on_outlined,
                          label: journal.location,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Divider(
                    color: AppColors.textMuted.withOpacity(0.2),
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),

                  // Story
                  Text('Story', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 12),
                  Text(
                    journal.story.isEmpty
                        ? 'No story written yet...'
                        : journal.story,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: journal.story.isEmpty
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        color: AppColors.primary,
        child: Center(
          child: Icon(
            Icons.landscape_outlined,
            size: 72,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
      );
    }

    if (kIsWeb) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: AppColors.primary,
          child: const Icon(Icons.broken_image, color: Colors.white, size: 48),
        ),
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.primary,
        child: const Icon(Icons.broken_image, color: Colors.white, size: 48),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Journal', style: AppTextStyles.titleLarge),
        content: Text(
          'Are you sure you want to delete this journal? This action cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<JournalProvider>().deleteJournal(journalId);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
