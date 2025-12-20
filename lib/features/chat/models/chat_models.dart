class ChatUser {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;

  ChatUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    final rawProfileUrl = json['profile_image_url']?.toString();
    final cleanedProfileUrl = (rawProfileUrl != null && rawProfileUrl.trim().isNotEmpty)
        ? rawProfileUrl.trim()
        : null;

    return ChatUser(
      id: (json['id'] as num).toInt(),
      username: (json['username'] ?? '').toString(),
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      profileImageUrl: cleanedProfileUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'profile_image_url': profileImageUrl,
    };
  }

  String get fullName => '$firstName $lastName'.trim();
  String get displayName => fullName.isEmpty ? username : fullName;
}

class ReplyToMessage {
  final int id;
  final String content;
  final String senderUsername;

  ReplyToMessage({
    required this.id,
    required this.content,
    required this.senderUsername,
  });

  factory ReplyToMessage.fromJson(Map<String, dynamic> json) {
    return ReplyToMessage(
      id: json['id'],
      content: json['content'] ?? '',
      senderUsername: json['sender_username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_username': senderUsername,
    };
  }
}

class PreSendAttachment {
  final String type; // 'course' | 'booking'
  final int id;
  final String? title;

  const PreSendAttachment._({
    required this.type,
    required this.id,
    this.title,
  });

  factory PreSendAttachment.course({
    required int courseId,
    required String title,
  }) {
    return PreSendAttachment._(type: 'course', id: courseId, title: title);
  }

  factory PreSendAttachment.booking({
    required int bookingId,
    String? title,
  }) {
    return PreSendAttachment._(type: 'booking', id: bookingId, title: title);
  }
}

class ChatAttachment {
  final String id;
  final String type;
  final String? fileUrl;
  final String? thumbnailUrl;
  final String fileName;
  final int? fileSize;
  final DateTime uploadedAt;
  final int? courseId;
  final String? courseName;
  final int? bookingId;
  final Map<String, dynamic>? data;

  ChatAttachment({
    required this.id,
    required this.type,
    this.fileUrl,
    this.thumbnailUrl,
    required this.fileName,
    this.fileSize,
    required this.uploadedAt,
    this.courseId,
    this.courseName,
    this.bookingId,
    this.data,
  });

  factory ChatAttachment.fromJson(Map<String, dynamic> json) {
    return ChatAttachment(
      id: json['id'],
      type: json['type'] ?? 'file',
      fileUrl: json['file_url'],
      thumbnailUrl: json['thumbnail_url'],
      fileName: json['file_name'] ?? 'Attachment',
      fileSize: json['file_size'],
      uploadedAt: DateTime.parse(json['uploaded_at']),
      courseId: json['course_id'],
      courseName: json['course_name'],
      bookingId: json['booking_id'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'file_url': fileUrl,
      'thumbnail_url': thumbnailUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'uploaded_at': uploadedAt.toIso8601String(),
      'course_id': courseId,
      'course_name': courseName,
      'booking_id': bookingId,
      'data': data,
    };
  }

  bool get isEmbed => type == 'course' || type == 'booking';
  bool get isFile => type == 'file';
  bool get isImage => type == 'image';
}

class ChatMessage {
  final int id;
  final String content;
  final DateTime timestamp;
  final ChatUser sender;
  final bool isSentByMe;
  final bool read;
  final List<ChatAttachment> attachments;
  final ReplyToMessage? replyTo;

  ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.sender,
    required this.isSentByMe,
    required this.read,
    this.attachments = const [],
    this.replyTo,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      sender: ChatUser.fromJson(json['sender']),
      isSentByMe: json['is_sent_by_me'] ?? false,
      read: json['read'] ?? false,
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((a) => ChatAttachment.fromJson(a))
              .toList()
          : [],
      replyTo: json['reply_to'] != null 
          ? ReplyToMessage.fromJson(json['reply_to']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'sender': sender.toJson(),
      'is_sent_by_me': isSentByMe,
      'read': read,
      'attachments': attachments.map((a) => a.toJson()).toList(),
      'reply_to': replyTo?.toJson(),
    };
  }
}

class ChatSession {
  final String id;
  final ChatUser user;
  final ChatUser coach;
  final DateTime startedAt;
  final DateTime? lastMessageAt;
  final ChatMessage? lastMessage;
  final int unreadCount;

  ChatSession({
    required this.id,
    required this.user,
    required this.coach,
    required this.startedAt,
    this.lastMessageAt,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      user: ChatUser.fromJson(json['user']),
      coach: ChatUser.fromJson(json['coach']),
      startedAt: DateTime.parse(json['started_at']),
      lastMessageAt: json['last_message_at'] != null 
          ? DateTime.parse(json['last_message_at']) 
          : null,
      lastMessage: json['last_message'] != null 
          ? ChatMessage.fromJson(json['last_message']) 
          : null,
      unreadCount: json['unread_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'coach': coach.toJson(),
      'started_at': startedAt.toIso8601String(),
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
    };
  }

  ChatUser getOtherUser(int currentUserId) {
    return user.id == currentUserId ? coach : user;
  }
}
