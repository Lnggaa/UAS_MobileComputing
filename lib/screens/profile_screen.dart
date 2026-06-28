import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/journal_provider.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Profile', style: AppTextStyles.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(
              Icons.logout_rounded,
              size: 18,
              color: AppColors.error,
            ),
            label: Text(
              'Logout',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
      body: Consumer2<AuthProvider, JournalProvider>(
        builder: (context, auth, journalProvider, _) {
          final user = auth.currentUser;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Avatar & identity dari data login
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                        );
                        if (picked != null) {
                          await auth.updatePhoto(picked.path);
                        }
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            backgroundImage: _buildPhotoImage(user?.photoPath),
                            child: user?.photoPath == null
                                ? const Icon(
                                    Icons.person_rounded,
                                    size: 56,
                                    color: AppColors.primary,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user?.name ?? 'Explorer',
                      style: AppTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Travel Journal Explorer',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Travel summary
              Text('My Travel Summary', style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      value: journalProvider.totalJournals.toString(),
                      label: 'Journeys',
                      icon: Icons.book_outlined,
                    ),
                    _VerticalDivider(),
                    _StatItem(
                      value: journalProvider.totalPhotos.toString(),
                      label: 'Photos',
                      icon: Icons.photo_camera_outlined,
                    ),
                    _VerticalDivider(),
                    _StatItem(
                      value: journalProvider.activeMonths.toString(),
                      label: 'Months',
                      icon: Icons.calendar_month_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recent destinations
              if (journalProvider.allJournals.isNotEmpty) ...[
                Text('Recent Destinations', style: AppTextStyles.titleLarge),
                const SizedBox(height: 12),
                ...journalProvider.allJournals
                    .take(5)
                    .map(
                      (journal) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.textMuted.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: AppColors.accent,
                                size: 18,
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
                                  if (journal.location.isNotEmpty)
                                    Text(
                                      journal.location,
                                      style: AppTextStyles.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.textMuted,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: 24),
              ],

              // About app
              Text('About App', style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textMuted.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.flight_takeoff_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Travel Journal',
                          style: AppTextStyles.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A personal travel documentation app built with Flutter. '
                      'Document your adventures with stories and photos, '
                      'stored securely offline on your device.',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Divider(color: AppColors.textMuted.withValues(alpha: 0.15)),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Version', value: '1.0.0'),
                    _InfoRow(label: 'Platform', value: 'Flutter (Android)'),
                    _InfoRow(label: 'Storage', value: 'Hive (Offline-first)'),
                    _InfoRow(label: 'Course', value: 'Mobile Computing UAS'),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  ImageProvider? _buildPhotoImage(String? photoPath) {
    if (photoPath == null) return null;
    if (kIsWeb) return NetworkImage(photoPath);
    return FileImage(File(photoPath));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Logout', style: AppTextStyles.titleLarge),
        content: Text(
          'Are you sure you want to logout?',
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
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 50, width: 1, color: Colors.white24);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
