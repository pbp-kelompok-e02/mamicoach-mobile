import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/models/booking.dart';
import 'package:mamicoach_mobile/services/booking_service.dart';
import 'package:mamicoach_mobile/widgets/common_error_widget.dart';
import 'package:mamicoach_mobile/widgets/common_empty_widget.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class CoachBookingsPage extends StatefulWidget {
  const CoachBookingsPage({super.key});

  @override
  State<CoachBookingsPage> createState() => _CoachBookingsPageState();
}

class _CoachBookingsPageState extends State<CoachBookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _allBookings = [];
  bool _isLoading = true;

  String? _errorMessage;
  bool _isConnectionError = false;

  final List<String> _tabs = ['Semua', 'Pending', 'Dibayar', 'Dikonfirmasi', 'Selesai'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = context.read<CookieRequest>();
      final bookings = await BookingService.getCoachBookings(request);
      
      if (mounted) {
        setState(() {
          _allBookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isConnectionError = e.toString().contains('SocketException') || 
                              e.toString().contains('Connection closed');
          _isLoading = false;
        });
      }
    }
  }

  List<Booking> _getFilteredBookings() {
    final selectedTab = _tabs[_tabController.index];
    
    if (selectedTab == 'Semua') {
      return _allBookings;
    } else if (selectedTab == 'Pending') {
      return _allBookings.where((b) => b.status == 'pending').toList();
    } else if (selectedTab == 'Dibayar') {
      return _allBookings.where((b) => b.status == 'paid').toList();
    } else if (selectedTab == 'Dikonfirmasi') {
      return _allBookings.where((b) => b.status == 'confirmed').toList();
    } else if (selectedTab == 'Selesai') {
      return _allBookings.where((b) => b.status == 'done').toList();
    }
    
    return _allBookings;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'paid':
        return Colors.blue;
      case 'confirmed':
        return AppColors.primaryGreen;
      case 'done':
        return Colors.grey;
      case 'canceled':
        return AppColors.coralRed;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'paid':
        return Icons.payment;
      case 'confirmed':
        return Icons.check_circle;
      case 'done':
        return Icons.done_all;
      case 'canceled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Future<void> _confirmBooking(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Konfirmasi Booking?',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin mengkonfirmasi booking ini?\n\nUser: ${booking.userName}\nKelas: ${booking.courseTitle}\nWaktu: ${booking.dateTimeFormatted}',
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Quicksand',
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Ya, Konfirmasi',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final request = context.read<CookieRequest>();
        await BookingService.updateBookingStatus(request, booking.id, 'confirmed');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Booking berhasil dikonfirmasi',
                style: TextStyle(fontFamily: 'Quicksand'),
              ),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
          _loadBookings();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().replaceAll('Exception: ', ''),
                style: const TextStyle(fontFamily: 'Quicksand'),
              ),
              backgroundColor: AppColors.coralRed,
            ),
          );
        }
      }
    }
  }

  Future<void> _rejectBooking(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Tolak Booking?',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menolak booking ini?\n\nBooking akan dibatalkan dan user akan diberi notifikasi.',
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Quicksand',
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Ya, Tolak',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                color: AppColors.coralRed,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final request = context.read<CookieRequest>();
        await BookingService.cancelBooking(request, booking.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Booking berhasil ditolak',
                style: TextStyle(fontFamily: 'Quicksand'),
              ),
              backgroundColor: AppColors.coralRed,
            ),
          );
          _loadBookings();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().replaceAll('Exception: ', ''),
                style: const TextStyle(fontFamily: 'Quicksand'),
              ),
              backgroundColor: AppColors.coralRed,
            ),
          );
        }
      }
    }
  }

  Future<void> _markAsDone(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Tandai Selesai?',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Apakah sesi ini sudah selesai? Tindakan ini akan menambah total jam mengajar Anda.',
          style: TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Quicksand',
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Ya, Selesai',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final request = context.read<CookieRequest>();
        await BookingService.updateBookingStatus(request, booking.id, 'done');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Booking ditandai selesai',
                style: TextStyle(fontFamily: 'Quicksand'),
              ),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
          _loadBookings();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().replaceAll('Exception: ', ''),
                style: const TextStyle(fontFamily: 'Quicksand'),
              ),
              backgroundColor: AppColors.coralRed,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Booking Masuk',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
          ),
          onTap: (index) {
            setState(() {});
          },
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : _buildBookingsList(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat booking...',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 16,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return CommonErrorWidget(
      message: _errorMessage ?? 'Terjadi kesalahan',
      isConnectionError: _isConnectionError,
      onRetry: _loadBookings,
    );
  }

  Widget _buildBookingsList() {
    final filteredBookings = _getFilteredBookings();

    if (filteredBookings.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      color: AppColors.primaryGreen,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = filteredBookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final selectedTab = _tabs[_tabController.index];
    
    return CommonEmptyWidget(
      title: 'Tidak Ada Booking',
      message: selectedTab == 'Semua'
          ? 'Belum ada booking masuk'
          : 'Tidak ada booking dengan status $selectedTab',
      icon: Icons.event_busy,
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final statusColor = _getStatusColor(booking.status);
    final statusIcon = _getStatusIcon(booking.status);
    final canConfirm = booking.status == 'paid';
    final canReject = booking.status == 'paid' || booking.status == 'pending';
    final canMarkDone = booking.status == 'confirmed';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: statusColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge and ID
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        booking.statusDisplay,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: #${booking.id}',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // User info
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.userName,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        'User',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Course title
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.class_,
                    size: 20,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.courseTitle,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Date & Time
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.darkGrey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    booking.dateTimeFormatted,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price
            Text(
              'Rp ${NumberFormat('#,###', 'id_ID').format(booking.price)}',
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),

            // Action buttons
            if (canConfirm || canReject || canMarkDone) ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (canConfirm) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmBooking(booking),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text(
                          'Konfirmasi',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (canReject)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _rejectBooking(booking),
                        icon: const Icon(Icons.cancel, size: 18),
                        label: const Text(
                          'Tolak',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.coralRed,
                          side: const BorderSide(color: AppColors.coralRed),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  if (canMarkDone)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _markAsDone(booking),
                        icon: const Icon(Icons.done_all, size: 18),
                        label: const Text(
                          'Selesai',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
