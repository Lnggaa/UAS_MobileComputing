import 'package:flutter/material.dart';
import '../utils/constants.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddJournal;

  const EmptyState({super.key, required this.onAddJournal});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.explore_outlined,
                size: 56,
                color: AppColors.primary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text('No Journeys Yet', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 10),
            Text(
              'Start documenting your adventures!\nEvery great journey begins with a single step.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onAddJournal,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create First Journal'),
            ),
          ],
        ),
      ),
    );
  }
}
