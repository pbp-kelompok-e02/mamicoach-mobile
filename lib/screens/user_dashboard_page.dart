import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/models/booking.dart';
import 'package:mamicoach_mobile/screens/user_profile_edit_page.dart';
import 'package:mamicoach_mobile/services/booking_service.dart';
import 'package:mamicoach_mobile/utils/snackbar_helper.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_helper.dart'; // Ensure this is correct
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mamicoach_mobile/features/review/models/reviews.dart';
import 'package:mamicoach_mobile/features/review/screens/review_form_screen.dart';
import 'package:mamicoach_mobile/features/review/services/review_service.dart';
import 'package:mamicoach_mobile/screens/payment_method_selection_page.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  List<Booking> _bookings = [];
  Map<int, Review> _reviewByBookingId = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final request = context.read<CookieRequest>();
      
      // 1. Fetch Profile
      final profileResponse = await request.get('${ApiConstants.baseUrl}/api/user-profile/');
      
      // 2. Fetch Bookings
      final bookings = await BookingService.getUserBookings(request);

      // 3. Fetch Reviews
      final myReviewsResult = await ReviewService.listMyReviews(request: request);
      final Map<int, Review> reviewByBookingId = {};
      
      if (myReviewsResult['success'] == true) {
        final reviews = (myReviewsResult['reviews'] as List<Review>?) ?? const [];
        for (final r in reviews) {
          if (r.bookingId > 0) {
            reviewByBookingId[r.bookingId] = r;
          }
        }
      }

      if (mounted) {
        setState(() {
          if (profileResponse['success'] == true) {
            _profileData = profileResponse['profile'];
          }
          _bookings = bookings;
          _reviewByBookingId = reviewByBookingId;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
        SnackBarHelper.showErrorSnackBar(context, 'Gagal memuat dashboard: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // ... Error handling omitted for brevity, assuming existing code covers it ...
    if (_errorMessage != null && _profileData == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_errorMessage'),
              ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    // Categorize Bookings
    final unpaidBookings = _bookings.where((b) => b.status == 'pending').toList();
    final inProcessBookings = _bookings.where((b) => b.status == 'confirmed').toList();
    final pendingBookings = _bookings.where((b) => b.status == 'paid').toList(); 
    final completedBookings = _bookings.where((b) => b.status == 'done').toList();
    final cancelledBookings = _bookings.where((b) => b.status == 'canceled').toList();

    return Scaffold(
      backgroundColor: Colors.grey[50], 
      appBar: AppBar(
        title: const Text(
          'Dashboard', 
          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Card
              _buildProfileCard(),
              const SizedBox(height: 16),

              // 2. Booking Sections
              _buildBookingSection('Unpaid Bookings', unpaidBookings, 'No unpaid bookings at the moment', isUnpaid: true),
              const SizedBox(height: 16),
              _buildBookingSection('In Process Bookings', inProcessBookings, 'No in-process bookings', isProcess: true),
              const SizedBox(height: 16),
              _buildBookingSection('Pending Bookings', pendingBookings, 'No pending bookings at the moment', isPending: true),
              const SizedBox(height: 16),
              _buildBookingSection('Completed Bookings', completedBookings, 'No completed bookings yet', isCompleted: true),
              const SizedBox(height: 16),
              _buildBookingSection('Recently Cancelled Bookings', cancelledBookings, 'No cancelled bookings', isCancelled: true),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final user = _profileData?['user'] ?? {};
    final firstName = user['first_name'] ?? '';
    final lastName = user['last_name'] ?? '';
    final fullName = '$firstName $lastName'.trim().isEmpty ? (user['username'] ?? 'User') : '$firstName $lastName';

    String? imageUrl = _profileData?['profile_image'];
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = '${ApiConstants.baseUrl}$imageUrl';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                  child: imageUrl == null 
                    ? const Icon(Icons.person, color: Colors.white, size: 28) 
                    : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    fullName,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const UserProfileEditPage()),
              ).then((_) => _loadData());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Edit Profile'),
          )
        ],
      ),
    );
  }

  Widget _buildBookingSection(String title, List<Booking> bookings, String emptyMessage, {bool isProcess = false, bool isCancelled = false, bool isCompleted = false, bool isPending = false, bool isUnpaid = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16), 
          if (bookings.isEmpty)
            Text(
              emptyMessage,
              style: TextStyle(
                fontFamily: 'Quicksand',
                color: Colors.grey[400],
                fontSize: 14,
              ),
            )
          else
            Column(
              children: bookings.map((b) => _buildBookingItem(b, isProcess: isProcess, isCancelled: isCancelled, isCompleted: isCompleted, isPending: isPending, isUnpaid: isUnpaid)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingItem(Booking booking, {bool isProcess = false, bool isCancelled = false, bool isCompleted = false, bool isPending = false, bool isUnpaid = false}) {

    // Basic date formatting
    final startStr = '${booking.startDatetime.day} ${_monthName(booking.startDatetime.month)} ${DateFormat('HH:mm').format(booking.startDatetime)}';
    final endStr = '${booking.endDatetime.day} ${_monthName(booking.endDatetime.month)} ${DateFormat('HH:mm').format(booking.endDatetime)}';
    final displayDate = '$startStr - $endStr';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with icon and text only
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.description_outlined, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: booking.courseTitle,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: ' with ${booking.coachName}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Bottom section with status badge or action buttons
          if (isPending || isCancelled || isProcess || isCompleted || isUnpaid) ...[
            const SizedBox(height: 12),
            if (isPending)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Waiting for Coach Confirmation',
                  style: TextStyle(color: AppColors.primaryGreen, fontSize: 12),
                ),
              ),
            if (isCancelled)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Cancelled', style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
            if (isProcess)
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => _openChat(booking),
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    side: const BorderSide(color: AppColors.primaryGreen),
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            if (isCompleted)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _openReviewForBooking(booking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Review', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            if (isUnpaid)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => _navigateToPayment(booking),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _cancelBooking(booking),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
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
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
             style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Tidak, Kembali'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final request = context.read<CookieRequest>();
        await BookingService.cancelBooking(request, booking.id);

        if (mounted) {
          SnackBarHelper.showSuccessSnackBar(context, 'Booking berhasil dibatalkan');
          _loadData();
        }
      } catch (e) {
        if (mounted) {
           SnackBarHelper.showErrorSnackBar(context, e.toString().replaceAll('Exception: ', ''));
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

    if (result == true) {
      _loadData();
    }
  }

  void _openReviewForBooking(Booking booking) async {
    final existingReview = _reviewByBookingId[booking.id];
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewFormScreen(
          bookingId: booking.id,
          courseId: booking.courseId,
          review: existingReview, 
        ),
      ),
    );
    // Refresh data after returning from review
    _loadData();
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }
  
  void _openChat(Booking booking) {
      ChatHelper.startChatWithCoach(
        context: context,
        coachId: booking.coachId,
        coachName: booking.coachName,
      );
  }
}
