import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart' as api_constants;
import 'package:mamicoach_mobile/core/widgets/proxy_network_image.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/screens/booking_detail_page.dart';
import 'package:mamicoach_mobile/screens/course_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onReply;

  const ChatBubble({
    super.key,
    required this.message,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final isOwn = message.isSentByMe;
    
    return Align(
      alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Column(
          crossAxisAlignment: isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.replyTo != null) _buildReplyContext(context, isOwn),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isOwn ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.content.isNotEmpty)
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isOwn ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  if (message.attachments.isNotEmpty) ...[
                    if (message.content.isNotEmpty) const SizedBox(height: 8),
                    ...message.attachments.map((att) => _buildAttachment(context, att, isOwn)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isOwn && onReply != null)
                  IconButton(
                    icon: const Icon(Icons.reply, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onReply,
                    color: Colors.grey,
                  ),
                const SizedBox(width: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                if (isOwn) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: message.read ? Colors.blue : Colors.grey,
                  ),
                ],
                if (isOwn && onReply != null)
                  IconButton(
                    icon: const Icon(Icons.reply, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onReply,
                    color: Colors.grey,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyContext(BuildContext context, bool isOwn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.replyTo!.senderUsername,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            message.replyTo!.content,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(BuildContext context, ChatAttachment attachment, bool isOwn) {
    if (attachment.isImage) {
      return Container(
        margin: const EdgeInsets.only(top: 4),
        child: _tappable(
          context: context,
          onTap: () => _openImagePreview(context, attachment),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ProxyNetworkImage(
              _absoluteUrl(attachment.fileUrl),
              fit: BoxFit.cover,
              placeholder: (context) => Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
        ),
      );
    } else if (attachment.isFile) {
      return Container(
        margin: const EdgeInsets.only(top: 4),
        child: _tappable(
          context: context,
          onTap: () => _openOrDownloadFile(context, attachment),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isOwn ? Colors.white.withOpacity(0.2) : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.insert_drive_file,
                  size: 20,
                  color: isOwn ? Colors.white : Colors.grey[700],
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    attachment.fileName,
                    style: TextStyle(
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      color: isOwn ? Colors.white : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (attachment.type == 'course') {
      return _buildCourseAttachment(context, attachment, isOwn);
    } else if (attachment.type == 'booking') {
      return _buildBookingAttachment(context, attachment, isOwn);
    }
    return const SizedBox.shrink();
  }

  Widget _buildCourseAttachment(BuildContext context, ChatAttachment attachment, bool isOwn) {
    final titleFromData = attachment.data != null ? (attachment.data!['title'] as String?) : null;
    final title = attachment.courseName ?? titleFromData ?? 'Unknown Course';

    final courseId = attachment.courseId ?? (attachment.data?['id'] as int?) ?? (attachment.data?['course_id'] as int?);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: _tappable(
        context: context,
        borderRadius: BorderRadius.circular(12),
        onTap: courseId == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailPage(courseId: courseId),
                  ),
                );
              },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isOwn
                  ? [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)]
                  : [Colors.purple[50]!, Colors.purple[100]!],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOwn ? Colors.white.withOpacity(0.3) : Colors.purple[200]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.school,
                    size: 20,
                    color: isOwn ? Colors.white : Colors.purple[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Course',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isOwn ? Colors.white : Colors.purple[900],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: isOwn ? Colors.white.withOpacity(0.9) : Colors.purple[700],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isOwn ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Lihat detail course',
                style: TextStyle(
                  fontSize: 12,
                  color: isOwn ? Colors.white.withOpacity(0.85) : Colors.purple[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingAttachment(BuildContext context, ChatAttachment attachment, bool isOwn) {
    final bookingId = attachment.bookingId ?? (attachment.data?['booking_id'] as int?) ?? (attachment.data?['id'] as int?);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: _tappable(
        context: context,
        borderRadius: BorderRadius.circular(12),
        onTap: bookingId == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingDetailPage(bookingId: bookingId),
                  ),
                );
              },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isOwn
                  ? [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)]
                  : [Colors.blue[50]!, Colors.blue[100]!],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOwn ? Colors.white.withOpacity(0.3) : Colors.blue[200]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: isOwn ? Colors.white : Colors.blue[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Booking',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isOwn ? Colors.white : Colors.blue[900],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: isOwn ? Colors.white.withOpacity(0.9) : Colors.blue[700],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Booking ID: ${bookingId ?? '-'}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isOwn ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Lihat detail booking',
                style: TextStyle(
                  fontSize: 12,
                  color: isOwn ? Colors.white.withOpacity(0.85) : Colors.blue[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _absoluteUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final u = url.trim();
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
    if (u.startsWith('/')) return '${api_constants.baseUrl}$u';
    return '${api_constants.baseUrl}/$u';
  }

  Widget _tappable({
    required BuildContext context,
    required Widget child,
    VoidCallback? onTap,
    BorderRadius? borderRadius,
  }) {
    if (onTap == null) return child;
    final radius = borderRadius ?? BorderRadius.circular(8);
    return ClipRRect(
      borderRadius: radius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: child,
        ),
      ),
    );
  }

  Future<void> _openOrDownloadFile(BuildContext context, ChatAttachment attachment) async {
    final url = _absoluteUrl(attachment.fileUrl);
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File URL tidak tersedia')),
      );
      return;
    }

    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka file')),
      );
    }
  }

  void _openImagePreview(BuildContext context, ChatAttachment attachment) {
    final url = _absoluteUrl(attachment.fileUrl);
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gambar tidak tersedia')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ProxyNetworkImage(
                    url,
                    fit: BoxFit.contain,
                    placeholder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute';

    if (difference.inDays == 0) {
      return timeStr;
    } else if (difference.inDays == 1) {
      return 'Yesterday $timeStr';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dateTime.month - 1]} ${dateTime.day}, $timeStr';
    }
  }
}
