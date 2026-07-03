import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants.dart';

class AppPermissionHandler {
  // Request camera permission
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await Permission.camera.request();
      if (result.isGranted) return true;

      if (context.mounted) {
        _showPermissionDialog(
          context,
          title: 'Izin Kamera Diperlukan',
          message:
              'Aplikasi memerlukan akses kamera untuk mengambil foto perjalanan kamu. '
              'Izin ini hanya digunakan saat kamu ingin menambahkan foto jurnal.',
          icon: Icons.camera_alt_rounded,
        );
      }
      return false;
    }

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showOpenSettingsDialog(
          context,
          title: 'Izin Kamera Diblokir',
          message:
              'Kamu telah memblokir izin kamera. Buka Pengaturan untuk mengaktifkannya '
              'agar dapat mengambil foto perjalanan.',
        );
      }
      return false;
    }

    return false;
  }

  // Request storage/gallery permission
  static Future<bool> requestStoragePermission(BuildContext context) async {
    // Android 13+ uses READ_MEDIA_IMAGES
    Permission permission = Permission.photos;

    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      if (result.isGranted) return true;

      if (context.mounted) {
        _showPermissionDialog(
          context,
          title: 'Izin Galeri Diperlukan',
          message:
              'Aplikasi memerlukan akses galeri untuk memilih foto perjalanan kamu. '
              'Izin ini hanya digunakan saat kamu ingin menambahkan foto jurnal.',
          icon: Icons.photo_library_rounded,
        );
      }
      return false;
    }

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showOpenSettingsDialog(
          context,
          title: 'Izin Galeri Diblokir',
          message:
              'Kamu telah memblokir izin galeri. Buka Pengaturan untuk mengaktifkannya '
              'agar dapat memilih foto perjalanan.',
        );
      }
      return false;
    }

    return false;
  }

  // Dialog penjelasan permission
  static void _showPermissionDialog(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: AppTextStyles.titleLarge)),
          ],
        ),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Mengerti',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog buka settings jika permanently denied
  static void _showOpenSettingsDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(
              Icons.settings_rounded,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: AppTextStyles.titleLarge)),
          ],
        ),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }
}
