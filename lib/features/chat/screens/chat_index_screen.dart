import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/features/chat/services/chat_service.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_session_entry.dart';
import 'package:mamicoach_mobile/features/chat/screens/chat_detail_screen.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ChatIndexScreen extends StatefulWidget {
  const ChatIndexScreen({super.key});

  @override
  State<ChatIndexScreen> createState() => _ChatIndexScreenState();
}

class _ChatIndexScreenState extends State<ChatIndexScreen> {
  List<ChatSession> _sessions = [];
  List<ChatSession> _filteredSessions = [];
  bool _isLoading = true;
  String _searchQuery = '';
  Timer? _pollingTimer;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadSessions();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        _loadSessions(silent: true);
      }
    });
  }

  Future<void> _loadSessions({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
      });
    }

    final request = context.read<CookieRequest>();
    final result = await ChatService.getChatSessions(request: request);

    if (!mounted) return;

    if (result['success'] == true) {
      setState(() {
        _sessions = result['sessions'] as List<ChatSession>;
        _filterSessions();
        _isLoading = false;
        if (_currentUserId == null && _sessions.isNotEmpty) {
          _currentUserId = _sessions.first.user.id;
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      if (!silent) {
        _showSnackBar(result['error'] ?? 'Failed to load chats', isError: true);
      }
    }
  }

  void _filterSessions() {
    if (_searchQuery.isEmpty) {
      _filteredSessions = _sessions;
    } else {
      _filteredSessions = _sessions.where((session) {
        final otherUser = session.getOtherUser(_currentUserId ?? 0);
        final name = otherUser.displayName.toLowerCase();
        final username = otherUser.username.toLowerCase();
        final lastMessage = session.lastMessage?.content.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        
        return name.contains(query) || 
               username.contains(query) || 
               lastMessage.contains(query);
      }).toList();
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadSessions(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isLoading && _sessions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _filteredSessions.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => _loadSessions(),
                        child: ListView.builder(
                          itemCount: _filteredSessions.length,
                          itemBuilder: (context, index) {
                            final session = _filteredSessions[index];
                            return ChatSessionEntry(
                              session: session,
                              currentUserId: _currentUserId ?? 0,
                              onTap: () => _openChat(session),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _filterSessions();
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _filterSessions();
          });
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty ? Icons.chat_bubble_outline : Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'No conversations yet'
                : 'No results found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Start a conversation with a coach'
                : 'Try a different search term',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(ChatSession session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(
          sessionId: session.id,
          otherUser: session.getOtherUser(_currentUserId ?? 0),
        ),
      ),
    ).then((_) {
      _loadSessions();
    });
  }
}
