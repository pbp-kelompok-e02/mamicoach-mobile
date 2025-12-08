import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/models/course.dart';
import 'package:mamicoach_mobile/models/course_detail.dart';
import 'package:mamicoach_mobile/models/category_model.dart';
import 'package:mamicoach_mobile/models/course_form_data.dart';
import 'package:mamicoach_mobile/config/environment.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course;
  final CourseDetail? courseDetail;

  const CourseFormPage({super.key, this.course, this.courseDetail});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _thumbnailController = TextEditingController();

  int? _selectedCategoryId;
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  bool _isFetchingCategories = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();

    // Handle CourseDetail
    if (widget.courseDetail != null) {
      _titleController.text = widget.courseDetail!.title;
      _descriptionController.text = widget.courseDetail!.description;
      _locationController.text = widget.courseDetail!.location;
      _priceController.text = widget.courseDetail!.price.toString();
      _durationController.text = widget.courseDetail!.duration.toString();
      _thumbnailController.text = widget.courseDetail!.thumbnailUrl ?? '';
      _selectedCategoryId = widget.courseDetail!.category.id;
    }
    // Handle Course
    else if (widget.course != null) {
      _titleController.text = widget.course!.title;
      _descriptionController.text = widget.course!.description;
      _locationController.text = widget.course!.location;
      _priceController.text = widget.course!.price.toString();
      _durationController.text = widget.course!.duration.toString();
      _thumbnailController.text = widget.course!.thumbnailUrl ?? '';
      _selectedCategoryId = widget.course!.category.id;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        '${Environment.baseUrl}/api/categories/',
      );
      if (response['success'] == true && response['data'] is List) {
        setState(() {
          _categories = (response['data'] as List)
              .map((json) => CategoryModel.fromJson(json))
              .toList();
          _isFetchingCategories = false;
        });
      }
    } catch (e) {
      setState(() => _isFetchingCategories = false);
      debugPrint('Error fetching categories: $e');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Pilih kategori kelas',
            style: TextStyle(fontFamily: 'Quicksand'),
          ),
          backgroundColor: AppColors.coralRed,
        ),
      );
      return;
    }

    // Create type-safe form data
    final formData = CourseFormData(
      categoryId: _selectedCategoryId!,
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      price: int.parse(_priceController.text),
      duration: int.parse(_durationController.text),
      thumbnailUrl: _thumbnailController.text.isNotEmpty
          ? _thumbnailController.text
          : null,
    );

    // Validate form data
    if (!formData.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Data tidak valid. Periksa kembali input Anda.',
            style: TextStyle(fontFamily: 'Quicksand'),
          ),
          backgroundColor: AppColors.coralRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final request = context.read<CookieRequest>();
    final isEdit = widget.course != null || widget.courseDetail != null;
    final courseId = widget.courseDetail?.id ?? widget.course?.id;

    try {
      final response = isEdit
          ? await request.post(
              '${Environment.baseUrl}/api/courses/$courseId/edit/',
              formData.toJson(),
            )
          : await request.post(
              '${Environment.baseUrl}/api/courses/create/',
              formData.toJson(),
            );

      if (mounted) {
        setState(() => _isLoading = false);

        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response['message'] ??
                    (isEdit
                        ? 'Kelas berhasil diperbarui'
                        : 'Kelas berhasil dibuat'),
                style: const TextStyle(fontFamily: 'Quicksand'),
              ),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response['message'] ?? 'Gagal menyimpan kelas',
                style: const TextStyle(fontFamily: 'Quicksand'),
              ),
              backgroundColor: AppColors.coralRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Terjadi kesalahan: $e',
              style: const TextStyle(fontFamily: 'Quicksand'),
            ),
            backgroundColor: AppColors.coralRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.course != null || widget.courseDetail != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Kelas' : 'Buat Kelas Baru',
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: _isFetchingCategories
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Judul Kelas *',
                      labelStyle: const TextStyle(fontFamily: 'Quicksand'),
                      hintText: 'Contoh: Beginner Yoga',
                      hintStyle: TextStyle(
                        fontFamily: 'Quicksand',
                        color: AppColors.darkGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(
                        Icons.title,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Quicksand'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul kelas wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: 'Kategori *',
                      labelStyle: const TextStyle(fontFamily: 'Quicksand'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(
                        Icons.category,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(
                          category.name,
                          style: const TextStyle(fontFamily: 'Quicksand'),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategoryId = value);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Kategori wajib dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi *',
                      labelStyle: const TextStyle(fontFamily: 'Quicksand'),
                      hintText: 'Jelaskan tentang kelas Anda',
                      hintStyle: TextStyle(
                        fontFamily: 'Quicksand',
                        color: AppColors.darkGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(
                        Icons.description,
                        color: AppColors.primaryGreen,
                      ),
                      alignLabelWithHint: true,
                    ),
                    style: const TextStyle(fontFamily: 'Quicksand'),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Lokasi *',
                      labelStyle: const TextStyle(fontFamily: 'Quicksand'),
                      hintText: 'Contoh: Online, Jakarta, Studio XYZ',
                      hintStyle: TextStyle(
                        fontFamily: 'Quicksand',
                        color: AppColors.darkGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Quicksand'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lokasi wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Harga *',
                            labelStyle: const TextStyle(
                              fontFamily: 'Quicksand',
                            ),
                            hintText: '150000',
                            hintStyle: TextStyle(
                              fontFamily: 'Quicksand',
                              color: AppColors.darkGrey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(
                              Icons.payments,
                              color: AppColors.primaryGreen,
                            ),
                            prefixText: 'Rp ',
                          ),
                          style: const TextStyle(fontFamily: 'Quicksand'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harga wajib diisi';
                            }
                            final price = int.tryParse(value);
                            if (price == null || price <= 0) {
                              return 'Harga harus lebih dari 0';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _durationController,
                          decoration: InputDecoration(
                            labelText: 'Durasi *',
                            labelStyle: const TextStyle(
                              fontFamily: 'Quicksand',
                            ),
                            hintText: '60',
                            hintStyle: TextStyle(
                              fontFamily: 'Quicksand',
                              color: AppColors.darkGrey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(
                              Icons.access_time,
                              color: AppColors.primaryGreen,
                            ),
                            suffixText: 'menit',
                          ),
                          style: const TextStyle(fontFamily: 'Quicksand'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Durasi wajib diisi';
                            }
                            final duration = int.tryParse(value);
                            if (duration == null || duration <= 0) {
                              return 'Durasi harus > 0';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _thumbnailController,
                    decoration: InputDecoration(
                      labelText: 'URL Gambar Kelas (Opsional)',
                      labelStyle: const TextStyle(fontFamily: 'Quicksand'),
                      hintText: 'https://example.com/image.jpg',
                      hintStyle: TextStyle(
                        fontFamily: 'Quicksand',
                        color: AppColors.darkGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(
                        Icons.image,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Quicksand'),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '* Wajib diisi',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      color: AppColors.darkGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              isEdit ? 'Simpan Perubahan' : 'Buat Kelas',
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
