import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/models/course_detail.dart';
import 'package:mamicoach_mobile/screens/booking_success_page.dart';
import 'package:mamicoach_mobile/services/booking_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookingConfirmationPage extends StatefulWidget {
  final CourseDetail course;
  final DateTime selectedDate;
  final Map<String, dynamic> selectedTimeSlot;
  final String? notes;

  const BookingConfirmationPage({
    super.key,
    required this.course,
    required this.selectedDate,
    required this.selectedTimeSlot,
    this.notes,
  });

  @override
  State<BookingConfirmationPage> createState() => _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  bool _isCreatingBooking = false;

  String get _formattedDate {
    final dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final dayName = dayNames[widget.selectedDate.weekday - 1];
    final date = DateFormat('d MMMM yyyy', 'id_ID').format(widget.selectedDate);
    return '$dayName, $date';
  }

  String get _formattedTimeRange {
    final startTime = DateTime.parse(widget.selectedTimeSlot['start_datetime']);
    final endTime = DateTime.parse(widget.selectedTimeSlot['end_datetime']);
    final startStr = DateFormat('HH:mm').format(startTime);
    final endStr = DateFormat('HH:mm').format(endTime);
    return '$startStr - $endStr WIB';
  }

  Duration get _duration {
    final startTime = DateTime.parse(widget.selectedTimeSlot['start_datetime']);
    final endTime = DateTime.parse(widget.selectedTimeSlot['end_datetime']);
    return endTime.difference(startTime);
  }

  String get _formattedDuration {
    final hours = _duration.inHours;
    final minutes = _duration.inMinutes % 60;
    if (minutes == 0) {
      return '$hours jam';
    }
    return '$hours jam $minutes menit';
  }

  Future<void> _confirmBooking() async {
    setState(() => _isCreatingBooking = true);

    try {
      final request = context.read<CookieRequest>();
      final startTime = DateTime.parse(widget.selectedTimeSlot['start_datetime']);
      final endTime = DateTime.parse(widget.selectedTimeSlot['end_datetime']);

      final response = await BookingService.createBooking(
        request,
        widget.course.id,
        widget.course.coach.id,
        startTime,
        endTime,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        // Navigate to success page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BookingSuccessPage(
              bookingId: response['booking_id'].toString(),
              course: widget.course,
              dateTime: _formattedDate,
              timeRange: _formattedTimeRange,
            ),
          ),
        );
      } else {
        _showErrorDialog(response['message'] ?? 'Gagal membuat booking');
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isCreatingBooking = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.error_outline,
          color: AppColors.coralRed,
          size: 64,
        ),
        title: const Text(
          'Booking Gagal',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Quicksand'),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Konfirmasi Booking',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryGreen.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primaryGreen,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pastikan detail booking Anda sudah benar sebelum melanjutkan ke pembayaran',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 13,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Course info
                  _buildSectionTitle('Detail Kelas'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.class_,
                      'Nama Kelas',
                      widget.course.title,
                    ),
                    _buildInfoRow(
                      Icons.person,
                      'Coach',
                      widget.course.coach.fullName,
                    ),
                    _buildInfoRow(
                      Icons.sports,
                      'Kategori',
                      widget.course.category.name,
                    ),
                    _buildInfoRow(
                      Icons.attach_money,
                      'Harga',
                      'Rp ${NumberFormat('#,###', 'id_ID').format(widget.course.price)}',
                      valueColor: AppColors.primaryGreen,
                      valueBold: true,
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Schedule info
                  _buildSectionTitle('Jadwal Booking'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Tanggal',
                      _formattedDate,
                    ),
                    _buildInfoRow(
                      Icons.access_time,
                      'Waktu',
                      _formattedTimeRange,
                    ),
                    _buildInfoRow(
                      Icons.timer,
                      'Durasi',
                      _formattedDuration,
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Notes (if any)
                  if (widget.notes != null && widget.notes!.isNotEmpty) ...[
                    _buildSectionTitle('Catatan'),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        widget.notes!,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Total payment
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen.withOpacity(0.1),
                          AppColors.primaryGreen.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryGreen.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        Text(
                          'Rp ${NumberFormat('#,###', 'id_ID').format(widget.course.price)}',
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isCreatingBooking ? null : _confirmBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isCreatingBooking
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Konfirmasi & Lanjut ke Pembayaran',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _isCreatingBooking ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Kembali',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      color: _isCreatingBooking ? Colors.grey : AppColors.darkGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Quicksand',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkGrey,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? AppColors.darkGrey,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
