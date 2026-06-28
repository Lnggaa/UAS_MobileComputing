import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';
import '../utils/constants.dart';
import '../widgets/journal_card.dart';
import '../widgets/empty_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(context),
            Expanded(child: _buildJournalList(context)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-journal'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          'New Journey',
          style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, Explorer! 👋', style: AppTextStyles.displayMedium),
              const SizedBox(height: 4),
              Consumer<JournalProvider>(
                builder: (context, provider, _) => Text(
                  '${provider.totalJournals} journeys recorded',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 2),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: TextField(
        onChanged: (value) =>
            context.read<JournalProvider>().setSearchQuery(value),
        decoration: InputDecoration(
          hintText: 'Search by title or location...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildJournalList(BuildContext context) {
    return Consumer<JournalProvider>(
      builder: (context, provider, _) {
        final journals = provider.journals;

        if (journals.isEmpty) {
          return EmptyState(
            onAddJournal: () => Navigator.pushNamed(context, '/add-journal'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          itemCount: journals.length,
          itemBuilder: (context, index) {
            final journal = journals[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: JournalCard(
                journal: journal,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/detail-journal',
                  arguments: journal.id,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Stats',
                isActive: false,
                onTap: () => Navigator.pushNamed(context, '/stats'),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isActive: false,
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.textMuted,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isActive ? AppColors.primary : AppColors.textMuted,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
