import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/models/course.dart';
import 'package:mamicoach_mobile/models/course_detail.dart';
import 'package:mamicoach_mobile/models/category_model.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart'
    as api_constants;
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

  // Controllers for handling input
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _thumbnailController = TextEditingController();

  int? _selectedCategoryId;
  List<CategoryModel> _categories = [];
  bool _isFetchingCategories = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _initializeFormData();
  }

  void _initializeFormData() {
    if (widget.courseDetail != null) {
      _titleController.text = widget.courseDetail!.title;
      _descriptionController.text = widget.courseDetail!.description;
      _locationController.text = widget.courseDetail!.location;
      _priceController.text = widget.courseDetail!.price.toString();
      _durationController.text = widget.courseDetail!.duration.toString();
      _thumbnailController.text = widget.courseDetail!.thumbnailUrl ?? '';
      _selectedCategoryId = widget.courseDetail!.category.id;
    } else if (widget.course != null) {
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
        '${api_constants.baseUrl}/api/categories/',
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isEdit = widget.course != null || widget.courseDetail != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Kelas' : 'Buat Kelas Baru'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isFetchingCategories
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Kelas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Isi detail lengkap mengenai kelas Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: "Judul Kelas *",
                          hintText: "Contoh: Beginner Yoga",
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'Quicksand'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Judul kelas wajib diisi!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Kategori *",
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        initialValue: _selectedCategoryId,
                        items: _categories.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(
                              category.name,
                              style: const TextStyle(fontFamily: 'Quicksand'),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCategoryId = value),
                        validator: (value) {
                          if (value == null) {
                            return "Kategori wajib dipilih!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "Deskripsi *",
                          hintText: "Jelaskan tentang kelas Anda",
                          prefixIcon: const Icon(Icons.description),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'Quicksand'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Deskripsi wajib diisi!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Location
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: "Lokasi *",
                          hintText: "Contoh: Online, Jakarta",
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'Quicksand'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Lokasi wajib diisi!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Price and Duration
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                labelText: "Harga *",
                                hintText: "0",
                                prefixText: "Rp ",
                                prefixIcon: const Icon(Icons.attach_money),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              style: const TextStyle(fontFamily: 'Quicksand'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Wajib diisi!";
                                }
                                if (int.tryParse(value) == null ||
                                    int.parse(value) < 0) {
                                  return "Harga tidak valid!";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _durationController,
                              decoration: InputDecoration(
                                labelText: "Durasi *",
                                hintText: "60",
                                suffixText: "menit",
                                prefixIcon: const Icon(Icons.access_time),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              style: const TextStyle(fontFamily: 'Quicksand'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Wajib diisi!";
                                }
                                if (int.tryParse(value) == null ||
                                    int.parse(value) <= 0) {
                                  return "Durasi > 0!";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Thumbnail URL
                      TextFormField(
                        controller: _thumbnailController,
                        decoration: InputDecoration(
                          labelText: "URL Gambar (Opsional)",
                          hintText: "https://example.com/image.jpg",
                          prefixIcon: const Icon(Icons.image),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'Quicksand'),
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!value.startsWith('http://') &&
                                !value.startsWith('https://')) {
                              return "URL harus diawali dengan http:// atau https://";
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: Text(
                            isEdit ? 'Simpan Perubahan' : 'Buat Kelas',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final courseId =
                                  widget.courseDetail?.id ?? widget.course?.id;
                              final url = isEdit
                                  ? '${api_constants.baseUrl}/api/courses/$courseId/edit/'
                                  : '${api_constants.baseUrl}/api/courses/create/';

                              final data = {
                                "category_id": _selectedCategoryId,
                                "title": _titleController.text,
                                "description": _descriptionController.text,
                                "location": _locationController.text,
                                "price": int.parse(_priceController.text),
                                "duration": int.parse(_durationController.text),
                                "thumbnail_url": _thumbnailController.text,
                              };

                              try {
                                final response = await request.postJson(
                                  url,
                                  jsonEncode(data),
                                );

                                if (mounted) {
                                  // Debug print
                                  print('Course creation response: $response');

                                  bool isSuccess = false;
                                  if (response is Map) {
                                    if (response['success'] == true)
                                      isSuccess = true;
                                    if (response['status'] == true)
                                      isSuccess = true;
                                    if (response['status'] == 'success')
                                      isSuccess = true;
                                  }

                                  if (isSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          response['message'] ??
                                              (isEdit
                                                  ? 'Kelas berhasil diperbarui'
                                                  : 'Kelas berhasil dibuat'),
                                          style: const TextStyle(
                                            fontFamily: 'Quicksand',
                                          ),
                                        ),
                                        backgroundColor: AppColors.primaryGreen,
                                      ),
                                    );
                                    Navigator.pop(context, true);
                                  } else {
                                    String errorMessage =
                                        'Gagal menyimpan kelas';
                                    if (response is Map &&
                                        response['error'] != null) {
                                      errorMessage = response['error'];
                                    } else if (response is Map &&
                                        response['message'] != null) {
                                      errorMessage = response['message'];
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          errorMessage,
                                          style: const TextStyle(
                                            fontFamily: 'Quicksand',
                                          ),
                                        ),
                                        backgroundColor: AppColors.coralRed,
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Terjadi kesalahan: $e',
                                        style: const TextStyle(
                                          fontFamily: 'Quicksand',
                                        ),
                                      ),
                                      backgroundColor: AppColors.coralRed,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
