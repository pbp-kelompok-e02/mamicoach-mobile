import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/providers/user_provider.dart';
import 'package:mamicoach_mobile/utils/snackbar_helper.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class CoachProfileEditPage extends StatefulWidget {
  const CoachProfileEditPage({super.key});

  @override
  State<CoachProfileEditPage> createState() => _CoachProfileEditPageState();
}

class _CoachProfileEditPageState extends State<CoachProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _certNameController = TextEditingController();
  final TextEditingController _certUrlController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _currentProfileImageUrl;
  Uint8List? _newProfileImageBytes;
  String? _profileImageBase64;
  final ImagePicker _picker = ImagePicker();

  // Expertise
  final List<String> _selectedExpertise = [];
  List<String> _availableExpertise = [];

  // Certifications
  List<Map<String, dynamic>> _existingCertifications = [];
  final List<Map<String, String>> _newCertifications = [];
  final List<int> _deletedCertificationIds = [];

  @override
  void initState() {
    super.initState();
    _loadCoachProfile();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        '${ApiConstants.baseUrl}/api/categories/',
      );
      if (response['success'] == true && response['data'] is List) {
        setState(() {
          _availableExpertise = (response['data'] as List)
              .map((e) => e['name'] as String)
              .toList();
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showErrorSnackBar(
          context,
          'Gagal mengambil daftar kategori: $e',
        );
      }
    }
  }

  Future<void> _loadCoachProfile() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        '${ApiConstants.baseUrl}/api/coach-profile/',
      );

      if (response['success'] == true) {
        setState(() {
          final profile = response['profile'];
          _firstNameController.text = profile['full_name']?.split(' ')[0] ?? '';
          _lastNameController.text = profile['full_name']?.split(' ').skip(1).join(' ') ?? '';
          _bioController.text = profile['bio'] ?? '';
          _currentProfileImageUrl = profile['profile_image'];
          
          // Set expertise
          if (profile['expertise'] is List) {
            _selectedExpertise.clear();
            _selectedExpertise.addAll((profile['expertise'] as List).cast<String>());
          }
          
          // Set certifications
          if (profile['certifications'] is List) {
            _existingCertifications = (profile['certifications'] as List)
                .map((cert) => {
                      'id': cert['id'],
                      'name': cert['name'],
                      'url': cert['url'],
                      'status': cert['status'],
                    })
                .toList();
          }
          
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        SnackBarHelper.showErrorSnackBar(
          context,
          'Gagal memuat profil: $e',
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _newProfileImageBytes = bytes;
          _profileImageBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showErrorSnackBar(
          context,
          'Gagal memilih gambar: $e',
        );
      }
    }
  }

  void _addNewCertification() {
    if (_certNameController.text.trim().isEmpty || 
        _certUrlController.text.trim().isEmpty) {
      SnackBarHelper.showErrorSnackBar(
        context,
        'Nama dan URL sertifikat tidak boleh kosong!',
      );
      return;
    }

    setState(() {
      _newCertifications.add({
        'name': _certNameController.text.trim(),
        'url': _certUrlController.text.trim(),
      });
      _certNameController.clear();
      _certUrlController.clear();
    });
  }

  void _removeNewCertification(int index) {
    setState(() {
      _newCertifications.removeAt(index);
    });
  }

  void _deleteExistingCertification(int index) {
    setState(() {
      final cert = _existingCertifications[index];
      _deletedCertificationIds.add(cert['id']);
      _existingCertifications.removeAt(index);
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedExpertise.isEmpty) {
      SnackBarHelper.showErrorSnackBar(
        context,
        'Pilih minimal satu keahlian!',
      );
      return;
    }

    setState(() => _isSaving = true);

    final request = context.read<CookieRequest>();

    try {
      final requestBody = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'bio': _bioController.text.trim(),
        'expertise': _selectedExpertise,
        'new_cert_names': _newCertifications.map((c) => c['name']).toList(),
        'new_cert_urls': _newCertifications.map((c) => c['url']).toList(),
        'deleted_certifications': _deletedCertificationIds,
      };

      // Add profile image if selected
      if (_profileImageBase64 != null && _profileImageBase64!.isNotEmpty) {
        requestBody['profile_image'] = 'data:image/jpeg;base64,$_profileImageBase64';
      }

      final response = await request.postJson(
        '${ApiConstants.baseUrl}/edit-profile/coach/',
        jsonEncode(requestBody),
      );

      if (mounted) {
        setState(() => _isSaving = false);

        if (response['success'] == true) {
          // Update user provider
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(
            userProvider.username ?? '',
            userProvider.isCoach,
            profilePicture: _newProfileImageBytes != null ? null : _currentProfileImageUrl,
          );

          SnackBarHelper.showSuccessSnackBar(
            context,
            response['message'] ?? 'Profil berhasil diperbarui!',
          );
          Navigator.pop(context, true);
        } else {
          SnackBarHelper.showErrorSnackBar(
            context,
            response['message'] ?? 'Gagal memperbarui profil',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        SnackBarHelper.showErrorSnackBar(
          context,
          'Terjadi kesalahan: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MainLayout(
        title: 'Edit Profil Coach',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return MainLayout(
      title: 'Edit Profil Coach',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image Section
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryGreen,
                            width: 4,
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: _newProfileImageBytes != null
                              ? Image.memory(
                                  _newProfileImageBytes!,
                                  fit: BoxFit.cover,
                                )
                              : (_currentProfileImageUrl != null &&
                                      _currentProfileImageUrl!.isNotEmpty)
                                  ? Image.network(
                                      _currentProfileImageUrl!.startsWith('http')
                                          ? _currentProfileImageUrl!
                                          : '${ApiConstants.baseUrl}$_currentProfileImageUrl',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.grey,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors.grey,
                                    ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Ubah Foto'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // First Name Field
              const Text(
                'Nama Depan',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama depan',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama depan tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Last Name Field
              const Text(
                'Nama Belakang',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama belakang',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama belakang tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Bio Field
              const Text(
                'Bio',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Ceritakan tentang diri Anda...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Bio tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Expertise Section
              const Text(
                'Keahlian',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableExpertise.map((expertise) {
                    final isSelected = _selectedExpertise.contains(expertise);
                    return FilterChip(
                      label: Text(expertise),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedExpertise.add(expertise);
                          } else {
                            _selectedExpertise.remove(expertise);
                          }
                        });
                      },
                      selectedColor: AppColors.primaryGreen.withOpacity(0.3),
                      checkmarkColor: AppColors.primaryGreen,
                      labelStyle: TextStyle(
                        fontFamily: 'Quicksand',
                        color: isSelected ? AppColors.primaryGreen : AppColors.grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Certifications Section
              const Text(
                'Sertifikat',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Existing Certifications
              if (_existingCertifications.isNotEmpty) ...[
                const Text(
                  'Sertifikat Anda:',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ..._existingCertifications.asMap().entries.map((entry) {
                  final index = entry.key;
                  final cert = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.verified,
                        color: cert['status'] == 'approved'
                            ? Colors.green
                            : cert['status'] == 'pending'
                                ? Colors.orange
                                : Colors.red,
                      ),
                      title: Text(
                        cert['name'],
                        style: const TextStyle(fontFamily: 'Quicksand'),
                      ),
                      subtitle: Text(
                        cert['url'],
                        style: const TextStyle(fontFamily: 'Quicksand'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteExistingCertification(index),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],

              // New Certifications
              if (_newCertifications.isNotEmpty) ...[
                const Text(
                  'Sertifikat Baru:',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ..._newCertifications.asMap().entries.map((entry) {
                  final index = entry.key;
                  final cert = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.green.shade50,
                    child: ListTile(
                      leading: const Icon(Icons.new_releases, color: Colors.green),
                      title: Text(
                        cert['name']!,
                        style: const TextStyle(fontFamily: 'Quicksand'),
                      ),
                      subtitle: Text(
                        cert['url']!,
                        style: const TextStyle(fontFamily: 'Quicksand'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeNewCertification(index),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],

              // Add Certification Form
              const Text(
                'Tambah Sertifikat Baru:',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _certNameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Sertifikat',
                        labelStyle: const TextStyle(fontFamily: 'Quicksand'),
                        hintText: 'e.g., Certified Trainer',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryGreen,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _certUrlController,
                      decoration: InputDecoration(
                        labelText: 'URL Sertifikat',
                        labelStyle: const TextStyle(fontFamily: 'Quicksand'),
                        hintText: 'https://...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryGreen,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addNewCertification,
                    icon: const Icon(Icons.add_circle),
                    color: AppColors.primaryGreen,
                    iconSize: 36,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _certNameController.dispose();
    _certUrlController.dispose();
    super.dispose();
  }
}
