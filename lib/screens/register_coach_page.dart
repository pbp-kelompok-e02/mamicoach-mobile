import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/screens/login_page.dart';
import 'package:mamicoach_mobile/screens/register_page.dart';
import 'package:mamicoach_mobile/widgets/custom_text_field.dart';
import 'package:mamicoach_mobile/widgets/custom_password_field.dart';
import 'package:mamicoach_mobile/widgets/custom_button.dart';
import 'package:mamicoach_mobile/utils/snackbar_helper.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class RegisterCoachPage extends StatefulWidget {
  const RegisterCoachPage({super.key});

  @override
  State<RegisterCoachPage> createState() => _RegisterCoachPageState();
}

class _RegisterCoachPageState extends State<RegisterCoachPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isLoading = false;

  // Profile image
  File? _profileImage;
  String? _profileImageBase64;
  final ImagePicker _picker = ImagePicker();

  // List untuk expertise
  final List<String> _selectedExpertise = [];
  List<String> _availableExpertise = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategories();
    });
  }

  Future<void> _fetchCategories() async {
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
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
        SnackBarHelper.showErrorSnackBar(
          context,
          'Gagal mengambil daftar kategori: $e',
        );
      }
    }
  }

  // Certifications
  final List<Map<String, String>> _certifications = [];
  final TextEditingController _certNameController = TextEditingController();
  final TextEditingController _certUrlController = TextEditingController();

  // ... (rest of methods)

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          if (!kIsWeb) {
            _profileImage = File(pickedFile.path);
          }
          _profileImageBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showErrorSnackBar(context, 'Gagal memilih gambar: $e');
      }
    }
  }

  void _addCertification() {
    if (_certNameController.text.isEmpty || _certUrlController.text.isEmpty) {
      SnackBarHelper.showErrorSnackBar(
        context,
        'Nama dan URL sertifikat tidak boleh kosong!',
      );
      return;
    }

    final url = _certUrlController.text;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      SnackBarHelper.showErrorSnackBar(
        context,
        'URL harus diawali dengan http:// atau https://',
      );
      return;
    }

    setState(() {
      _certifications.add({
        'name': _certNameController.text,
        'url': _certUrlController.text,
      });
      _certNameController.clear();
      _certUrlController.clear();
    });
  }

  void _removeCertification(int index) {
    setState(() {
      _certifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Daftar Sebagai Coach',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bagikan keahlian Anda dan mulai mengajar',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Quicksand',
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // User Registration Link
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: AppColors.grey, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Hanya ingin belajar?',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            color: AppColors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Daftar User',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Username TextField
                CustomTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  hintText: 'Masukkan username',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // First Name TextField
                CustomTextField(
                  controller: _firstNameController,
                  labelText: 'Nama Depan',
                  hintText: 'Masukkan nama depan',
                  prefixIcon: Icons.badge,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama depan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Last Name TextField
                CustomTextField(
                  controller: _lastNameController,
                  labelText: 'Nama Belakang',
                  hintText: 'Masukkan nama belakang',
                  prefixIcon: Icons.badge_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama belakang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Bio TextField
                CustomTextField(
                  controller: _bioController,
                  labelText: 'Bio',
                  hintText: 'Ceritakan tentang pengalaman dan keahlian Anda...',
                  prefixIcon: Icons.description,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bio tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Expertise Selection
                const Text(
                  'Keahlian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih minimal satu keahlian',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Quicksand',
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                _isLoadingCategories
                    ? const Center(child: CircularProgressIndicator())
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableExpertise.map((expertise) {
                          final isSelected = _selectedExpertise.contains(
                            expertise,
                          );
                          return FilterChip(
                            label: Text(
                              expertise,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.black,
                              ),
                            ),
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
                            selectedColor: AppColors.primaryGreen,
                            checkmarkColor: Colors.white,
                            backgroundColor: AppColors.lightGrey.withOpacity(
                              0.3,
                            ),
                          );
                        }).toList(),
                      ),
                const SizedBox(height: 24),

                // Profile Image Section (Optional)
                const Text(
                  'Foto Profil (Opsional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tambahkan foto profil Anda',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Quicksand',
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.lightGrey.withOpacity(0.3),
                          border: Border.all(
                            color: AppColors.primaryGreen,
                            width: 2,
                          ),
                        ),
                        child:
                            _profileImage != null || _profileImageBase64 != null
                            ? ClipOval(
                                child: kIsWeb
                                    ? Image.memory(
                                        base64Decode(_profileImageBase64!),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        _profileImage!,
                                        fit: BoxFit.cover,
                                      ),
                              )
                            : Icon(
                                Icons.person,
                                size: 80,
                                color: AppColors.grey,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _profileImage != null ||
                                      _profileImageBase64 != null
                                  ? Icons.edit
                                  : Icons.add_a_photo,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                      if (_profileImage != null || _profileImageBase64 != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _profileImage = null;
                                  _profileImageBase64 = null;
                                });
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Certifications Section (Optional)
                const Text(
                  'Sertifikat (Opsional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tambahkan sertifikat atau pelatihan yang Anda miliki',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Quicksand',
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 12),

                // Certification Input
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _certNameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Sertifikat',
                          labelStyle: const TextStyle(fontFamily: 'Quicksand'),
                          hintText: 'e.g., Certified Fitness Trainer',
                          hintStyle: const TextStyle(fontFamily: 'Quicksand'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.lightGrey),
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
                          hintStyle: const TextStyle(fontFamily: 'Quicksand'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.lightGrey),
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
                      onPressed: _addCertification,
                      icon: const Icon(Icons.add_circle),
                      color: AppColors.primaryGreen,
                      iconSize: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Certifications List
                if (_certifications.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryGreen.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sertifikat Ditambahkan (${_certifications.length})',
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _certifications.length,
                          itemBuilder: (context, index) {
                            final cert = _certifications[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.workspace_premium,
                                  color: AppColors.primaryGreen,
                                ),
                                title: Text(
                                  cert['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  cert['url']!,
                                  style: const TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeCertification(index),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Password TextField
                CustomPasswordField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Masukkan password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password TextField
                CustomPasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Konfirmasi Password',
                  hintText: 'Masukkan ulang password',
                  prefixIcon: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (value != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Register Button
                CustomButton(
                  text: 'Daftar Sebagai Coach',
                  isLoading: _isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedExpertise.isEmpty) {
                        SnackBarHelper.showErrorSnackBar(
                          context,
                          'Pilih minimal satu keahlian!',
                        );
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        // Prepare request body
                        final requestBody = {
                          'username': _usernameController.text,
                          'first_name': _firstNameController.text,
                          'last_name': _lastNameController.text,
                          'password1': _passwordController.text,
                          'password2': _confirmPasswordController.text,
                          'bio': _bioController.text,
                          'expertise': _selectedExpertise,
                          'certifications': _certifications,
                        };

                        // Add profile_image only if provided
                        if (_profileImageBase64 != null &&
                            _profileImageBase64!.isNotEmpty) {
                          requestBody['profile_image'] =
                              'data:image/jpeg;base64,$_profileImageBase64';
                        }

                        // Ganti dengan URL backend Anda
                        final response = await request.postJson(
                          "${ApiConstants.baseUrl}/auth/api_register_coach/",
                          jsonEncode(requestBody),
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        if (context.mounted) {
                          if (response['status'] == true) {
                            SnackBarHelper.showSuccessSnackBar(
                              context,
                              response['message'] ??
                                  'Registrasi coach berhasil!',
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          } else {
                            SnackBarHelper.showErrorSnackBar(
                              context,
                              response['message'] ?? 'Registrasi gagal!',
                            );
                          }
                        }
                      } catch (e) {
                        setState(() {
                          _isLoading = false;
                        });

                        if (context.mounted) {
                          SnackBarHelper.showErrorSnackBar(
                            context,
                            'Terjadi kesalahan: $e',
                          );
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: AppColors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bioController.dispose();
    _certNameController.dispose();
    _certUrlController.dispose();
    super.dispose();
  }
}
