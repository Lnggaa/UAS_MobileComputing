import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';
import '../utils/constants.dart';
import '../widgets/stat_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Travel Stats', style: AppTextStyles.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<JournalProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Summary cards
              Text('Overview', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.book_outlined,
                      label: 'Journeys',
                      value: provider.totalJournals.toString(),
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.photo_camera_outlined,
                      label: 'Photos',
                      value: provider.totalPhotos.toString(),
                      color: AppColors.olive,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.calendar_month_outlined,
                      label: 'Active Months',
                      value: provider.activeMonths.toString(),
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Chart
              Text('Journeys Per Month', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              _buildBarChart(provider),

              const SizedBox(height: 32),

              // Recent activity
              if (provider.allJournals.isNotEmpty) ...[
                Text('Recent Activity', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 16),
                ...provider.allJournals
                    .take(3)
                    .map(
                      (journal) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.textMuted.withOpacity(0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.book_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    journal.title,
                                    style: AppTextStyles.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    journal.location.isNotEmpty
                                        ? journal.location
                                        : 'No location',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildBarChart(JournalProvider provider) {
    final data = provider.journalsByMonth;

    if (data.isEmpty) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.textMuted.withOpacity(0.15)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                size: 48,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 8),
              Text('No data yet', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      );
    }

    final sortedKeys = data.keys.toList()..sort();
    final maxValue = data.values.reduce((a, b) => a > b ? a : b);
    final displayKeys = sortedKeys.length > 6
        ? sortedKeys.sublist(sortedKeys.length - 6)
        : sortedKeys;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textMuted.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 164,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: displayKeys.map((key) {
                final value = data[key] ?? 0;
                final heightRatio = maxValue > 0 ? value / maxValue : 0.0;
                final parts = key.split('-');
                final month = parts.length > 1 ? parts[1] : key;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          value.toString(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: (120 * heightRatio).clamp(4.0, 120.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('M$month', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
