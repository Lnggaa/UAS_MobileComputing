import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/journal.dart';
import '../providers/journal_provider.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../utils/permission_handler.dart' as ph;

class AddJournalScreen extends StatefulWidget {
  final String? journalId;

  const AddJournalScreen({super.key, this.journalId});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _storyController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _imagePath;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.journalId != null) {
      _isEditing = true;
      _loadJournalData();
    }
  }

  void _loadJournalData() {
    final provider = context.read<JournalProvider>();
    final journal = provider.getJournalById(widget.journalId!);
    if (journal != null) {
      _titleController.text = journal.title;
      _locationController.text = journal.location;
      _storyController.text = journal.story;
      _selectedDate = journal.travelDate;
      _imagePath = journal.imagePath;
    }
  }

  @override
  void dispose() {
    // Efisiensi resource: dispose semua controller saat widget dihapus dari tree
    _titleController.dispose();
    _locationController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Web tidak perlu permission handler
    if (kIsWeb) {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) setState(() => _imagePath = picked.path);
      return;
    }

    // Android: cek permission galeri dulu
    if (!mounted) return;
    final hasPermission =
        await ph.AppPermissionHandler.requestStoragePermission(context);
    if (!hasPermission) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _imagePath = picked.path);
    }
  }

  Future<void> _pickFromCamera() async {
    // Web: fallback ke galeri
    if (kIsWeb) {
      _pickImage();
      return;
    }

    // Android: cek permission kamera dulu
    if (!mounted) return;
    final hasPermission = await ph.AppPermissionHandler.requestCameraPermission(
      context,
    );
    if (!hasPermission) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _imagePath = picked.path);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveJournal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = context.read<JournalProvider>();
      final now = DateTime.now();

      if (_isEditing) {
        final journal = provider.getJournalById(widget.journalId!);
        if (journal != null) {
          journal.title = _titleController.text.trim();
          journal.location = _locationController.text.trim();
          journal.travelDate = _selectedDate;
          journal.story = _storyController.text.trim();
          journal.imagePath = _imagePath;
          await provider.updateJournal(journal);
        }
      } else {
        final journal = Journal(
          id: now.millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          location: _locationController.text.trim(),
          travelDate: _selectedDate,
          story: _storyController.text.trim(),
          imagePath: _imagePath,
          createdAt: now,
        );
        await provider.addJournal(journal);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      // Error handling: tampilkan snackbar jika gagal simpan
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan jurnal: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Edit Story' : 'Create New Story',
          style: AppTextStyles.titleLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Image section
            _buildImageSection(),
            const SizedBox(height: 24),

            // Title
            _buildLabel('Journal Title *'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              style: AppTextStyles.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'e.g. Sunrise at Bromo...',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                if (value.trim().length < 5) {
                  return 'Title must be at least 5 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Location
            _buildLabel('Location'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              style: AppTextStyles.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'e.g. Probolinggo, East Java',
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date
            _buildLabel('Travel Date'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textMuted.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormatter.formatDate(_selectedDate),
                      style: AppTextStyles.bodyLarge,
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Story
            _buildLabel('Your Story'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _storyController,
              style: AppTextStyles.bodyLarge,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText:
                    'Write about your experience, feelings, and memories...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveJournal,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Journal'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: AppTextStyles.labelMedium);
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Cover Photo'),
        const SizedBox(height: 8),
        if (_imagePath != null)
          _buildImagePreview()
        else
          _buildImagePlaceholder(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickFromCamera,
                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                label: Text(
                  kIsWeb ? 'Upload Photo' : 'Camera',
                  style: AppTextStyles.labelMedium,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library_outlined, size: 18),
                label: Text('Gallery', style: AppTextStyles.labelMedium),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.olive,
                  side: const BorderSide(color: AppColors.olive),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 48,
            color: AppColors.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a cover photo',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: kIsWeb
              ? Image.network(
                  _imagePath!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                )
              : Image.file(
                  File(_imagePath!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => setState(() => _imagePath = null),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
