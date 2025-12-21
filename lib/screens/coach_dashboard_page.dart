import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/models/booking.dart';
import 'package:mamicoach_mobile/screens/coach_profile_edit_page.dart';
import 'package:mamicoach_mobile/screens/course_form_page.dart';
import 'package:mamicoach_mobile/screens/my_courses_page.dart';
import 'package:mamicoach_mobile/services/booking_service.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/features/chat/screens/chat_detail_screen.dart';
import 'package:mamicoach_mobile/features/chat/services/chat_service.dart';
import 'package:mamicoach_mobile/utils/snackbar_helper.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CoachDashboardPage extends StatefulWidget {
  const CoachDashboardPage({super.key});

  @override
  State<CoachDashboardPage> createState() => _CoachDashboardPageState();
}

class _CoachDashboardPageState extends State<CoachDashboardPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  List<Booking> _bookings = [];
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
      final profileResponse = await request.get('${ApiConstants.baseUrl}/api/coach-profile/');
      
      // 2. Fetch Bookings
      final bookings = await BookingService.getCoachBookings(request);

      if (mounted) {
        setState(() {
          if (profileResponse['success'] == true) {
            _profileData = profileResponse['profile'];
          }
          _bookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
        SnackBarHelper.showErrorSnackBar(context, 'Gagal memuat data dashboard: $e');
      }
    }
  }

  Future<void> _confirmBooking(Booking booking) async {
    try {
      final request = context.read<CookieRequest>();
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await BookingService.confirmBooking(request, booking.id);
      
      if (mounted) {
        Navigator.pop(context); // Pop loading
        SnackBarHelper.showSuccessSnackBar(context, 'Booking accepted');
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Pop loading
        SnackBarHelper.showErrorSnackBar(context, 'Failed to accept: $e');
      }
    }
  }

  Future<void> _completeBooking(Booking booking) async {
    try {
      final request = context.read<CookieRequest>();
       showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await BookingService.completeBooking(request, booking.id);
      
      if (mounted) {
        Navigator.pop(context);
        SnackBarHelper.showSuccessSnackBar(context, 'Booking marked as complete');
        _loadData();
      }
    } catch (e) {
       if (mounted) {
        Navigator.pop(context);
        SnackBarHelper.showErrorSnackBar(context, 'Failed to complete: $e');
      }
    }
  }

  Future<void> _cancelBooking(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Booking?'),
        content: const Text('Are you sure you want to decline this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red), 
            child: const Text('Decline'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final request = context.read<CookieRequest>();
         showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        await BookingService.cancelBooking(request, booking.id);
        
        if (mounted) {
          Navigator.pop(context);
          SnackBarHelper.showSuccessSnackBar(context, 'Booking declined');
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          SnackBarHelper.showErrorSnackBar(context, 'Failed to decline: $e');
        }
      }
    }
  }

  void _openChat(Booking booking) async {
    final request = context.read<CookieRequest>();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await ChatService.createChatWithUser(
      userId: booking.userId,
      request: request,
    );

    if (!mounted) return;
    Navigator.pop(context); // pop loading

    if (result['success'] == true) {
      final otherUser = result['other_user'] != null
          ? ChatUser.fromJson(result['other_user'] as Map<String, dynamic>)
          : ChatUser(
              id: booking.userId,
              username: booking.userName.replaceAll(' ', '_'),
              firstName: booking.userName,
              lastName: '',
            );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(
            sessionId: result['session_id'],
            otherUser: otherUser,
          ),
        ),
      );
    } else {
      SnackBarHelper.showErrorSnackBar(context, result['error'] ?? 'Failed to start chat');
    }
  }

  Future<void> _launchURL(String urlString) async {
    if (urlString.trim().isEmpty) return;
    
    if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
      urlString = 'https://$urlString';
    }

    try {
      final Uri url = Uri.parse(urlString);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          SnackBarHelper.showErrorSnackBar(context, 'Tidak dapat membuka link');
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showErrorSnackBar(context, 'Link tidak valid');
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

    // Prepare Booking Subsets
    final inProcessBookings = _bookings.where((b) => b.status == 'confirmed').toList();
    final pendingBookings = _bookings.where((b) => b.status == 'pending' || b.status == 'paid').toList();
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildRevenueCard(),
              const SizedBox(height: 20),
              _buildClassesSection(),
              const SizedBox(height: 16),
              _buildBookingsSection('In Process Bookings', inProcessBookings, 'No in-process bookings at the moment'),
              const SizedBox(height: 16),
              _buildBookingsSection('Pending Bookings', pendingBookings, 'No pending bookings at the moment'),
              const SizedBox(height: 16),
              _buildBookingsSection('Completed Bookings', completedBookings, 'No completed bookings yet'),
              const SizedBox(height: 16),
              _buildBookingsSection('Recently Cancelled Bookings', cancelledBookings, 'No cancelled bookings'),
              
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
    final fullName = '$firstName $lastName'.trim().isEmpty ? (user['username'] ?? 'Coach') : '$firstName $lastName';
    final bio = _profileData?['bio'] ?? 'No bio available';
    
    // Categories - using 'expertise' as per existing data structure seen in Edit Profile or 'categories'
    // Edit page uses 'expertise' (List<String>), Dashboard might receive 'categories' (List<Map>) or 'expertise'
    String categories = 'No categories';
    if (_profileData?['expertise'] != null && _profileData!['expertise'] is List) {
       categories = (_profileData!['expertise'] as List).join(', ');
    } else if (_profileData?['categories'] != null && _profileData!['categories'] is List) {
       categories = (_profileData!['categories'] as List).map((c) => c['name'] ?? c.toString()).join(', ');
    }

    // Image
    String? imageUrl = _profileData?['profile_image'];
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = '${ApiConstants.baseUrl}$imageUrl';
    }

    // Rating - default to 4.0 as per user request if not available
    final double rating = (_profileData?['rating'] is num) 
        ? (_profileData!['rating'] as num).toDouble() 
        : 4.0;

    // Certifications
    final certifications = (_profileData?['certifications'] as List?) ?? [];
    final hasCerts = certifications.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 30, // Adjusted size
                backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                backgroundColor: Colors.grey[200],
                child: imageUrl == null ? const Icon(Icons.person, size: 30, color: Colors.grey) : null,
              ),
              const SizedBox(width: 16),
              // Name, Cats & Stars
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            fullName,
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                         // Dynamic stars
                         Row(
                           children: [
                             ...List.generate(5, (index) {
                               if (index < rating.floor()) {
                                 return const Icon(Icons.star, color: AppColors.primaryGreen, size: 16);
                               } else if (index < rating && (rating - index) >= 0.5) {
                                 return const Icon(Icons.star_half, color: AppColors.primaryGreen, size: 16);
                               } else {
                                  // Grey star for empty
                                 return Icon(Icons.star, color: Colors.grey[300], size: 16);
                               }
                             }),
                           ],
                         ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categories,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Bio
          const Text(
            'Bio',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            bio,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // Certifications
          const Text(
            'Certifications',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          if (!hasCerts)
            Text(
              'No certificates added yet',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Column(
              children: certifications.map<Widget>((cert) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                           const Icon(Icons.circle, color: Colors.blue, size: 12),
                           const SizedBox(width: 8),
                           Text(
                            cert['name'],
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            // The provided snippet seems to be for a different context,
                            // but if it's intended to be added here, it needs a 'profileImage' variable.
                            // Assuming the instruction was to modify the existing imageUrl logic for CircleAvatar.
                            // If this was meant to be a new image display for certifications,
                            // it would need a 'profileImage' variable defined in this scope.
                            // For now, I'm leaving this section as is, as the instruction was about
                            // updating the NetworkImage URL logic, which I applied to the CircleAvatar.
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () => _launchURL(cert['url'] ?? ''),
                            child: const Icon(Icons.open_in_new, size: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 20),
          
          // Edit Profile Button
          SizedBox(
            width: double.infinity, 
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CoachProfileEditPage()),
                ).then((_) => _loadData());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Edit Profile', 
                style: TextStyle(
                  fontFamily: 'Quicksand', 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard() {
    final balance = _profileData?['balance'] ?? 0;
    final formattedBalance = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ', 
      decimalDigits: 0
    ).format(balance);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.attach_money, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Withdrawable Income',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        formattedBalance,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Placeholder action
                    SnackBarHelper.showSuccessSnackBar(context, "Request Withdraw feature coming soon!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Request Withdraw'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Classes',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCoursesPage()),
                );
              },
              child: const Text(
                'View',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Create Class Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, style: BorderStyle.none),
             boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Icon(Icons.add, size: 40, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Ready to share your expertise?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Create a new class and start teaching today',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CourseFormPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Create Class', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingsSection(String title, List<Booking> bookings, String emptyMessage) {
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 12),
          
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
              children: bookings.map((b) => _buildBookingCard(b)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final status = booking.status.toLowerCase();
    bool isPending = status == 'pending' || status == 'paid'; 
    bool isConfirmed = status == 'confirmed';
    bool isCompleted = status == 'done';
    bool isCancelled = status == 'canceled' || status == 'cancelled';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Container(
             width: 48,
             height: 48,
             alignment: Alignment.center,
             decoration: BoxDecoration(
               color: Colors.grey[100],
               borderRadius: BorderRadius.circular(8),
             ),
             child: Icon(
               Icons.description_outlined,
               color: Colors.grey[600],
               size: 24,
             ),
           ),
           const SizedBox(width: 16),
           
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
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                    children: [
                      TextSpan(
                        text: ' with ${booking.userName}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                 ),
                 const SizedBox(height: 4),
                 Text(
                   _formatBookingDateTime(booking.startDatetime, booking.endDatetime),
                   style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                 ),
               ],
             ),
           ),

           if (isConfirmed) ...[
              OutlinedButton.icon(
                onPressed: () => _openChat(booking),
                icon: const Icon(Icons.chat_bubble_outline, size: 16),
                label: const Text('Chat'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(color: AppColors.primaryGreen),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _completeBooking(booking),
                 style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                child: const Text('Mark as Complete'),
              ),
           ] else if (isPending) ...[
              ElevatedButton(
                onPressed: () => _confirmBooking(booking),
                 style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                child: const Text('Accept'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _cancelBooking(booking),
                 style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                child: const Text('Decline'),
              ),
           ] else if (isCompleted) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
           ] else if (isCancelled) ...[
               Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Cancelled',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
           ],
        ],
      ),
    );
  }

  String _formatBookingDateTime(DateTime start, DateTime end) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    
    String formatSingle(DateTime dt) {
      return '${dt.day} ${months[dt.month - 1]} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return '${formatSingle(start)} - ${formatSingle(end)}';
  }
}
