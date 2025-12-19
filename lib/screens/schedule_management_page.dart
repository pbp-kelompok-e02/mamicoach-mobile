import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/models/coach_availability.dart';
import 'package:mamicoach_mobile/services/schedule_service.dart';
import 'package:mamicoach_mobile/widgets/common_error_widget.dart';
import 'package:mamicoach_mobile/widgets/common_empty_widget.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ScheduleManagementPage extends StatefulWidget {
  const ScheduleManagementPage({super.key});

  @override
  State<ScheduleManagementPage> createState() => _ScheduleManagementPageState();
}

class _ScheduleManagementPageState extends State<ScheduleManagementPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<CoachAvailability> _availabilities = [];
  List<DateTime> _datesWithAvailability = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isConnectionError = false;

  @override
  void initState() {
    super.initState();
    _loadAvailabilities();
  }

  Future<void> _loadAvailabilities() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = context.read<CookieRequest>();
      
      // Load availabilities for current month and next 2 months
      final startDate = DateTime(_focusedDay.year, _focusedDay.month, 1);
      final endDate = DateTime(_focusedDay.year, _focusedDay.month + 3, 0);
      
      final availabilities = await ScheduleService.getAvailabilities(
        request,
        startDate: startDate,
        endDate: endDate,
      );

      setState(() {
        _availabilities = availabilities;
        _datesWithAvailability = availabilities
            .map((a) => DateTime(a.date.year, a.date.month, a.date.day))
            .toSet()
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isConnectionError = e.toString().contains('SocketException') || 
                            e.toString().contains('Connection closed');
        _isLoading = false;
      });
    }
  }

  bool _hasAvailabilityOnDate(DateTime day) {
    return _datesWithAvailability.any((date) =>
        date.year == day.year &&
        date.month == day.month &&
        date.day == day.day);
  }

  List<CoachAvailability> _getAvailabilitiesForDate(DateTime date) {
    return _availabilities.where((a) =>
        a.date.year == date.year &&
        a.date.month == date.month &&
        a.date.day == date.day).toList();
  }

  Future<void> _showAddAvailabilityDialog({CoachAvailability? editAvailability}) async {
    final isEdit = editAvailability != null;
    DateTime selectedDate = editAvailability?.date ?? _selectedDay ?? DateTime.now();
    TimeOfDay startTime = editAvailability != null
        ? TimeOfDay(
            hour: int.parse(editAvailability.startTime.split(':')[0]),
            minute: int.parse(editAvailability.startTime.split(':')[1]),
          )
        : const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = editAvailability != null
        ? TimeOfDay(
            hour: int.parse(editAvailability.endTime.split(':')[0]),
            minute: int.parse(editAvailability.endTime.split(':')[1]),
          )
        : const TimeOfDay(hour: 17, minute: 0);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    isEdit ? Icons.edit_calendar : Icons.add_circle_outline,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEdit ? 'Edit Ketersediaan' : 'Tambah Ketersediaan',
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Date selector
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text(
                  'Tanggal',
                  style: TextStyle(fontFamily: 'Quicksand'),
                ),
                subtitle: Text(
                  DateFormat('EEEE, dd MMMM yyyy', 'id').format(selectedDate),
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setModalState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
              const Divider(),
              
              // Start time selector
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: const Text(
                  'Waktu Mulai',
                  style: TextStyle(fontFamily: 'Quicksand'),
                ),
                subtitle: Text(
                  startTime.format(context),
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: startTime,
                  );
                  if (picked != null) {
                    setModalState(() {
                      startTime = picked;
                    });
                  }
                },
              ),
              const Divider(),
              
              // End time selector
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: const Text(
                  'Waktu Selesai',
                  style: TextStyle(fontFamily: 'Quicksand'),
                ),
                subtitle: Text(
                  endTime.format(context),
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: endTime,
                  );
                  if (picked != null) {
                    setModalState(() {
                      endTime = picked;
                    });
                  }
                },
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
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
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _saveAvailability(
                        editAvailability?.id,
                        selectedDate,
                        startTime,
                        endTime,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isEdit ? 'Simpan' : 'Tambah',
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
    );
  }

  Future<void> _saveAvailability(
    int? availabilityId,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) async {
    // Validation
    if (startTime.hour >= endTime.hour && startTime.minute >= endTime.minute) {
      _showErrorSnackBar('Waktu mulai harus lebih awal dari waktu selesai');
      return;
    }

    Navigator.pop(context); // Close dialog

    _showLoadingSnackBar('Menyimpan ketersediaan...');

    try {
      final request = context.read<CookieRequest>();
      final startTimeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
      final endTimeStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

      // If editing, delete the old availability first
      if (availabilityId != null) {
        await ScheduleService.deleteAvailability(request, availabilityId);
        // Wait a bit to ensure delete completes
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final response = await ScheduleService.upsertAvailability(
        request,
        date: date,
        startTime: startTimeStr,
        endTime: endTimeStr,
      );

      if (response['success'] == true) {
        _showSuccessSnackBar(
          availabilityId != null
              ? 'Ketersediaan berhasil diperbarui'
              : 'Ketersediaan berhasil ditambahkan',
        );
        // Reload data to show new availability
        await _loadAvailabilities();
      } else {
        _showErrorSnackBar(response['message'] ?? 'Gagal menyimpan ketersediaan');
      }
    } catch (e) {
      _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> _deleteAvailability(CoachAvailability availability) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Hapus Ketersediaan',
          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ketersediaan pada ${availability.dateFormatted} pukul ${availability.timeRangeFormatted}?',
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(fontFamily: 'Quicksand')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coralRed,
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(fontFamily: 'Quicksand', color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    _showLoadingSnackBar('Menghapus ketersediaan...');

    try {
      final request = context.read<CookieRequest>();
      final response = await ScheduleService.deleteAvailability(request, availability.id);

      if (response['success'] == true) {
        _showSuccessSnackBar('Ketersediaan berhasil dihapus');
        await _loadAvailabilities();
      } else {
        _showErrorSnackBar(response['message'] ?? 'Gagal menghapus ketersediaan');
      }
    } catch (e) {
      _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _showLoadingSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(message, style: const TextStyle(fontFamily: 'Quicksand')),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontFamily: 'Quicksand'),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontFamily: 'Quicksand'),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.coralRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Atur Ketersediaan',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAvailabilities,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_errorMessage != null && _availabilities.isEmpty) {
      return Center(
        child: CommonErrorWidget(
          message: _errorMessage!,
          isConnectionError: _isConnectionError,
          onRetry: _loadAvailabilities,
        ),
      );
    }

    return Column(
      children: [
        _buildCalendarSection(),
        _buildAddButton(),
        const SizedBox(height: 8),
        Expanded(child: _buildAvailabilitiesList()),
      ],
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showAddAvailabilityDialog(),
          icon: const Icon(Icons.add),
          label: const Text(
            'Tambah Jadwal Baru',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month, color: AppColors.primaryGreen),
              SizedBox(width: 8),
              Text(
                'Kalender Ketersediaan',
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
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.primaryGreen),
              rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.primaryGreen),
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
              markerDecoration: const BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: const TextStyle(fontFamily: 'Quicksand'),
            ),
            eventLoader: (day) {
              return _hasAvailabilityOnDate(day) ? [day] : [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _loadAvailabilities();
            },
          ),
          const SizedBox(height: 12),
          _buildCalendarLegend(),
        ],
      ),
    );
  }

  Widget _buildCalendarLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem(
          color: AppColors.lightGreen,
          label: 'Ada Jadwal',
        ),
        _buildLegendItem(
          color: AppColors.primaryGreen,
          label: 'Dipilih',
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
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

  Widget _buildAvailabilitiesList() {
    final displayAvailabilities = _selectedDay != null
        ? _getAvailabilitiesForDate(_selectedDay!)
        : _availabilities;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.list, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedDay != null
                        ? 'Jadwal ${DateFormat('dd MMMM yyyy', 'id').format(_selectedDay!)}'
                        : 'Semua Jadwal',
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_selectedDay != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDay = null;
                      });
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(fontFamily: 'Quicksand'),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // List Content
          Expanded(
            child: displayAvailabilities.isEmpty
                ? CommonEmptyWidget(
                    title: _selectedDay != null
                        ? 'Tidak ada jadwal'
                        : 'Belum ada jadwal',
                    message: _selectedDay != null
                        ? 'Tidak ada jadwal pada tanggal ini'
                        : 'Klik tombol "Tambah Jadwal Baru" untuk menambah jadwal',
                    icon: Icons.event_available,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayAvailabilities.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildAvailabilityCard(displayAvailabilities[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityCard(CoachAvailability availability) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppColors.primaryGreen.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${availability.dayName}, ${availability.dateFormatted}',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: availability.isPast ? Colors.grey : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.darkGrey,
                ),
                const SizedBox(width: 8),
                Text(
                  availability.timeRangeFormatted,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    color: availability.isPast ? Colors.grey : AppColors.darkGrey,
                  ),
                ),
              ],
            ),
            if (availability.isPast)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Jadwal sudah terlewat',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!availability.isPast)
                  TextButton.icon(
                    onPressed: () => _showAddAvailabilityDialog(editAvailability: availability),
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text(
                      'Edit',
                      style: TextStyle(fontFamily: 'Quicksand', fontSize: 12),
                    ),
                  ),
                TextButton.icon(
                  onPressed: () => _deleteAvailability(availability),
                  icon: const Icon(Icons.delete, size: 20, color: AppColors.coralRed),
                  label: const Text(
                    'Hapus',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      color: AppColors.coralRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
