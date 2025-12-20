import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_helper.dart';
import 'package:mamicoach_mobile/features/review/models/reviews.dart';
import 'package:mamicoach_mobile/features/review/screens/review_form_screen.dart';
import 'package:mamicoach_mobile/features/review/services/review_service.dart';
import 'package:mamicoach_mobile/models/booking.dart';
import 'package:mamicoach_mobile/services/booking_service.dart';
import 'package:mamicoach_mobile/screens/payment_method_selection_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class MyBookingsPage extends StatefulWidget {
  final int? initialBookingId;

  const MyBookingsPage({super.key, this.initialBookingId});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _allBookings = [];
  Map<int, Review> _reviewByBookingId = {};
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> _tabs = ['Semua', 'Pending', 'Dibayar', 'Selesai', 'Dibatalkan'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    // If we came here from a chat booking attachment, jump to "Semua".
    if (widget.initialBookingId != null) {
      _tabController.index = 0;
    }

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
      final bookings = await BookingService.getUserBookings(request);

      // Load user's reviews (used to switch "Beri Review" vs "Update Review")
      final myReviewsResult = await ReviewService.listMyReviews(request: request);
      final Map<int, Review> reviewByBookingId = {};
      if (myReviewsResult['success'] == true) {
        final reviews = (myReviewsResult['reviews'] as List<Review>?) ?? const [];
        for (final r in reviews) {
          // bookingId is required; still guard for safety
          if (r.bookingId > 0) {
            reviewByBookingId[r.bookingId] = r;
          }
        }
      }
      
      if (mounted) {
        setState(() {
          _allBookings = bookings;
          _reviewByBookingId = reviewByBookingId;
          _isLoading = false;
        });

        _openInitialBookingIfNeeded();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  void _openInitialBookingIfNeeded() {
    final id = widget.initialBookingId;
    if (id == null) return;

    // Ensure we're on "Semua" so the item is present.
    if (_tabController.index != 0) {
      _tabController.animateTo(0);
    }

    final booking = _allBookings.where((b) => b.id == id).cast<Booking?>().firstWhere(
          (b) => b != null,
          orElse: () => null,
        );
    if (booking == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showBookingDetail(booking);
    });
  }

  List<Booking> _getFilteredBookings() {
    final selectedTab = _tabs[_tabController.index];
    
    if (selectedTab == 'Semua') {
      return _allBookings;
    } else if (selectedTab == 'Pending') {
      return _allBookings.where((b) => b.status == 'pending').toList();
    } else if (selectedTab == 'Dibayar') {
      return _allBookings.where((b) => b.status == 'paid' || b.status == 'confirmed').toList();
    } else if (selectedTab == 'Selesai') {
      return _allBookings.where((b) => b.status == 'done').toList();
    } else if (selectedTab == 'Dibatalkan') {
      return _allBookings.where((b) => b.status == 'canceled').toList();
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

  Future<void> _cancelBooking(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Batalkan Booking?',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin membatalkan booking untuk "${booking.courseTitle}"?\n\nTindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Tidak',
              style: TextStyle(
                fontFamily: 'Quicksand',
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Ya, Batalkan',
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
                'Booking berhasil dibatalkan',
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

  Future<void> _navigateToPayment(Booking booking) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodSelectionPage(
          bookingId: booking.id,
          amount: booking.price.toInt(),
        ),
      ),
    );

    // If payment was completed, refresh the bookings
    if (result == true) {
      _loadBookings();
    }
  }

  Future<void> _openChatForBooking(Booking booking) async {
    await ChatHelper.startChatWithCoach(
      context: context,
      coachId: booking.coachId,
      coachName: booking.coachName,
      preSendMessage:
          'Halo Coach ${booking.coachName}, saya ingin bertanya terkait booking #${booking.id} untuk kelas "${booking.courseTitle}".',
      preSendAttachment: PreSendAttachment.booking(
        bookingId: booking.id,
        title: booking.courseTitle,
      ),
    );
  }

  Future<void> _openReviewForBooking(Booking booking, {Review? existing}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewFormScreen(
          review: existing,
          bookingId: existing == null ? booking.id : null,
          courseId: existing == null ? booking.courseId : null,
        ),
      ),
    );

    // Refresh reviews after create/edit so button label stays accurate
    if (mounted) {
      _loadBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Booking Saya',
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat Booking',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Terjadi kesalahan',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadBookings,
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
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak Ada Booking',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              selectedTab == 'Semua'
                  ? 'Anda belum memiliki booking apapun'
                  : 'Tidak ada booking dengan status $selectedTab',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final statusColor = _getStatusColor(booking.status);
    final statusIcon = _getStatusIcon(booking.status);
    final canCancel = booking.status == 'pending';
    final canChatCoach = booking.status == 'pending' ||
        booking.status == 'paid' ||
        booking.status == 'confirmed';
    final existingReview = _reviewByBookingId[booking.id];

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
      child: InkWell(
        onTap: () => _showBookingDetail(booking),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge
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

              // Course title
              Text(
                booking.courseTitle,
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Coach
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.darkGrey,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      booking.coachName,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

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

              // Price and Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rp ${NumberFormat('#,###', 'id_ID').format(booking.price)}',
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  if (canCancel)
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _navigateToPayment(booking),
                          icon: const Icon(Icons.payment, size: 16),
                          label: const Text(
                            'Bayar Sekarang',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _cancelBooking(booking),
                          icon: const Icon(Icons.cancel, size: 20),
                          tooltip: 'Batalkan',
                          color: AppColors.coralRed,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                ],
              ),

              if (canChatCoach) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openChatForBooking(booking),
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text(
                      'Chat Coach',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],

              if (booking.status == 'done') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openReviewForBooking(
                      booking,
                      existing: existingReview,
                    ),
                    icon: const Icon(Icons.reviews, size: 18),
                    label: Text(
                      existingReview == null ? 'Beri Review' : 'Update Review',
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingDetail(Booking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Status badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(booking.status),
                              size: 20,
                              color: _getStatusColor(booking.status),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              booking.statusDisplay,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(booking.status),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Booking ID
                    Center(
                      child: Text(
                        'Booking ID: #${booking.id}',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Course info
                    _buildDetailSection(
                      'Detail Kelas',
                      [
                        _buildDetailRow(Icons.class_, 'Nama Kelas', booking.courseTitle),
                        _buildDetailRow(Icons.person, 'Coach', booking.coachName),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Schedule info
                    _buildDetailSection(
                      'Jadwal',
                      [
                        _buildDetailRow(Icons.calendar_today, 'Tanggal', booking.dateFormatted),
                        _buildDetailRow(Icons.access_time, 'Waktu', booking.timeFormatted),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Payment info
                    _buildDetailSection(
                      'Pembayaran',
                      [
                        _buildDetailRow(
                          Icons.payment,
                          'Total',
                          'Rp ${NumberFormat('#,###', 'id_ID').format(booking.price)}',
                          valueColor: AppColors.primaryGreen,
                          valueBold: true,
                        ),
                        _buildDetailRow(
                          Icons.schedule,
                          'Dibuat',
                          DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(booking.createdAt),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
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
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                color: Colors.grey[600],
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
