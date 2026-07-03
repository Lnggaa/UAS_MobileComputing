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
              'Kamu telah memblokir izin kamera. Buka Pengaturan untuk mengaktifkannya.',
        );
      }
      return false;
    }

    return false;
  }

  // Request storage/gallery permission - handle semua versi Android
  static Future<bool> requestStoragePermission(BuildContext context) async {
    // Coba permission photos dulu (Android 13+)
    PermissionStatus status = await Permission.photos.status;

    // Kalau photos tidak supported, fallback ke storage (Android < 13)
    if (status == PermissionStatus.restricted ||
        status == PermissionStatus.limited) {
      return true;
    }

    // Langsung request tanpa dialog penjelasan dulu
    if (status.isDenied) {
      final result = await Permission.photos.request();

      // Kalau photos denied, coba storage
      if (result.isDenied || result.isPermanentlyDenied) {
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted) return true;

        final storageResult = await Permission.storage.request();
        if (storageResult.isGranted) return true;

        // Kalau masih denied, tampilkan dialog
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

      if (result.isGranted) return true;
    }

    if (status.isGranted) return true;

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

    return true;
  }

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
