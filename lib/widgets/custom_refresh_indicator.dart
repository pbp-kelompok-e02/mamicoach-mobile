import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'dart:math' as math;

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final double triggerDistance;
  final Color? color;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.triggerDistance = 80.0,
    this.color,
  });

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _dragOffset = ValueNotifier(0.0);
  late AnimationController _animationController;
  bool _isRefreshing = false;
  final double _maxDragOffset = 120.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _dragOffset.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startRefresh() async {
    if (_isRefreshing) return;
    
    setState(() => _isRefreshing = true);
    
    // Animate to trigger distance to show loading spinner
    await _animateTo(widget.triggerDistance);

    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
        await _animateTo(0);
      }
    }
  }

  Future<void> _animateTo(double target) {
    final start = _dragOffset.value;
    _animationController.reset();
    
    final animation = Tween<double>(begin: start, end: target).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    animation.addListener(() {
      _dragOffset.value = animation.value;
    });

    return _animationController.forward();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_isRefreshing) return false;

    if (notification is OverscrollNotification) {
      if (notification.overscroll < 0) {
        // Pulling down (overscroll is negative)
        double newOffset = _dragOffset.value - (notification.overscroll * 0.5);
        _dragOffset.value = newOffset.clamp(0.0, _maxDragOffset);
      }
    } else if (notification is ScrollUpdateNotification) {
      // Handle dragging back up while pulled down
      if (_dragOffset.value > 0 && notification.scrollDelta != null) {
        if (notification.metrics.extentBefore == 0) {
           double newOffset = _dragOffset.value - (notification.scrollDelta! * 0.5);
           _dragOffset.value = newOffset.clamp(0.0, _maxDragOffset);
        }
      }
    } else if (notification is ScrollEndNotification) {
      if (_dragOffset.value >= widget.triggerDistance) {
        _startRefresh();
      } else if (_dragOffset.value > 0) {
        _animateTo(0);
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final indicatorColor = widget.color ?? AppColors.primaryGreen;

    return Stack(
      children: [
        // 1. The Indicator
        ValueListenableBuilder<double>(
          valueListenable: _dragOffset,
          builder: (context, offset, _) {
            final double progress = (offset / widget.triggerDistance).clamp(0.0, 1.0);
            
            if (offset == 0 && !_isRefreshing) return const SizedBox.shrink();

            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: offset,
              child: Container(
                alignment: Alignment.center,
                child: _isRefreshing
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                        ),
                      )
                    : Transform.scale(
                        scale: progress,
                        child: CustomPaint(
                          size: const Size(24, 24),
                          painter: _CircleProgressPainter(
                            progress: progress,
                            color: indicatorColor,
                          ),
                        ),
                      ),
              ),
            );
          },
        ),

        // 2. The Content
        ValueListenableBuilder<double>(
          valueListenable: _dragOffset,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: Offset(0, offset),
              child: child,
            );
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                physics: const ClampingScrollPhysics(),
              ),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircleProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // Start from top
        sweepAngle,
        false,
        progressPaint,
      );
    }

    // Center dot that grows with progress
    if (progress > 0.5) {
      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      final dotRadius = (progress - 0.5) * 2 * 6; // Max 6px radius
      canvas.drawCircle(center, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
