import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/models/course_detail.dart';
import 'package:mamicoach_mobile/screens/booking_confirmation_page.dart';
import 'package:mamicoach_mobile/services/booking_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class BookingFormPage extends StatefulWidget {
  final CourseDetail course;

  const BookingFormPage({super.key, required this.course});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  // State variables
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, dynamic>? _selectedTimeSlot;
  List<DateTime> _availableDates = [];
  List<Map<String, dynamic>> _availableTimeSlots = [];
  bool _isLoadingDates = true;
  bool _isLoadingTimes = false;
  String? _errorMessage;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAvailableDates();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableDates() async {
    setState(() {
      _isLoadingDates = true;
      _errorMessage = null;
    });

    try {
      final request = context.read<CookieRequest>();
      final dates = await BookingService.getAvailableDates(
        request,
        widget.course.coach.id,
        widget.course.id,
      );

      setState(() {
        _availableDates = dates;
        _isLoadingDates = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoadingDates = false;
      });
    }
  }

  Future<void> _loadAvailableTimes(DateTime date) async {
    setState(() {
      _isLoadingTimes = true;
      _selectedTimeSlot = null;
      _errorMessage = null;
    });

    try {
      final request = context.read<CookieRequest>();
      final times = await BookingService.getAvailableTimes(
        request,
        widget.course.coach.id,
        widget.course.id,
        date,
        widget.course.duration, // Pass course duration in minutes
      );

      setState(() {
        _availableTimeSlots = times;
        _isLoadingTimes = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoadingTimes = false;
      });
    }
  }

  void _goToConfirmation() {
    if (_selectedDay == null || _selectedTimeSlot == null) {
      _showErrorDialog('Mohon pilih tanggal dan waktu terlebih dahulu');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationPage(
          course: widget.course,
          selectedDate: _selectedDay!,
          selectedTimeSlot: _selectedTimeSlot!,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 64,
        ),
        title: const Text(
          'Gagal Membuat Booking',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(fontFamily: 'Quicksand'),
            ),
          ),
        ],
      ),
    );
  }

  bool _isDateAvailable(DateTime day) {
    return _availableDates.any((date) =>
        date.year == day.year &&
        date.month == day.month &&
        date.day == day.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Booking Kelas',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoadingDates
          ? _buildLoadingState()
          : _errorMessage != null && _availableDates.isEmpty
              ? _buildErrorState()
              : _buildContent(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Memuat jadwal tersedia...',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Jadwal',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Coach belum mengatur jadwal untuk kelas ini',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadAvailableDates,
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(fontFamily: 'Quicksand'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCourseHeader(),
          const SizedBox(height: 8),
          _buildCalendarSection(),
          if (_selectedDay != null) ...[
            const SizedBox(height: 8),
            _buildTimeSlotSection(),
          ],
          if (_selectedTimeSlot != null) ...[
            const SizedBox(height: 8),
            _buildSummarySection(),
          ],
          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildCourseHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Course thumbnail
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
              image: widget.course.thumbnailUrl != null
                  ? DecorationImage(
                      image: NetworkImage(widget.course.thumbnailUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: widget.course.thumbnailUrl == null
                ? const Icon(Icons.image, size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          // Course info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.course.title,
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.course.coach.fullName,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      widget.course.durationFormatted,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.course.location,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.course.priceFormatted,
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: AppColors.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Pilih Tanggal',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 90)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            enabledDayPredicate: _isDateAvailable,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: AppColors.primaryGreen,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: AppColors.primaryGreen,
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: const TextStyle(
                fontFamily: 'Quicksand',
                color: Colors.red,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              disabledTextStyle: TextStyle(
                fontFamily: 'Quicksand',
                color: Colors.grey[300],
              ),
              defaultTextStyle: const TextStyle(
                fontFamily: 'Quicksand',
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (_isDateAvailable(selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _loadAvailableTimes(selectedDay);
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 12),
          _buildCalendarLegend(),
        ],
      ),
    );
  }

  Widget _buildCalendarLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          color: AppColors.primaryGreen,
          label: 'Tersedia',
        ),
        const SizedBox(width: 16),
        _buildLegendItem(
          color: Colors.grey[300]!,
          label: 'Tidak Tersedia',
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: AppColors.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pilih Waktu (${DateFormat('dd MMMM yyyy', 'id').format(_selectedDay!)})',
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoadingTimes)
            _buildTimeSlotsSkeleton()
          else if (_availableTimeSlots.isEmpty)
            _buildNoTimeSlotsAvailable()
          else
            _buildTimeSlotGrid(),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsSkeleton() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildNoTimeSlotsAvailable() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'Tidak ada slot waktu tersedia',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih tanggal lain atau hubungi coach',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: _availableTimeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = _availableTimeSlots[index];
        final isSelected = _selectedTimeSlot == timeSlot;
        
        final startTime = DateTime.parse(timeSlot['start_datetime']);
        final endTime = DateTime.parse(timeSlot['end_datetime']);
        final timeLabel = '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}';

        return InkWell(
          onTap: () {
            setState(() {
              _selectedTimeSlot = timeSlot;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryGreen : Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.primaryGreen : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                timeLabel,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummarySection() {
    final startTime = DateTime.parse(_selectedTimeSlot!['start_datetime']);
    final endTime = DateTime.parse(_selectedTimeSlot!['end_datetime']);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long,
                color: AppColors.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Ringkasan Booking',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildSummaryRow(
            icon: Icons.calendar_today,
            label: 'Tanggal',
            value: DateFormat('EEEE, dd MMMM yyyy', 'id').format(startTime),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            icon: Icons.access_time,
            label: 'Waktu',
            value: '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)} WIB',
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            icon: Icons.timer,
            label: 'Durasi',
            value: widget.course.durationFormatted,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            icon: Icons.location_on,
            label: 'Lokasi',
            value: widget.course.location,
          ),
          const Divider(height: 24),
          _buildSummaryRow(
            icon: Icons.payment,
            label: 'Total Pembayaran',
            value: widget.course.priceFormatted,
            valueStyle: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Catatan (Opsional)',
              hintText: 'Tambahkan catatan untuk coach...',
              labelStyle: const TextStyle(fontFamily: 'Quicksand'),
              hintStyle: TextStyle(
                fontFamily: 'Quicksand',
                color: Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primaryGreen,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: valueStyle ??
                    const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomBar() {
    if (_selectedTimeSlot == null) return null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primaryGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _goToConfirmation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lanjutkan',
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
    );
  }
}
