import 'package:flutter/material.dart';

class SequenceLoader extends StatefulWidget {
  final double size;
  final Color? color;
  final Duration frameDuration;

  const SequenceLoader({
    super.key,
    this.size = 50.0,
    this.color,
    this.frameDuration = const Duration(milliseconds: 150),
  });

  @override
  State<SequenceLoader> createState() => _SequenceLoaderState();
}

class _SequenceLoaderState extends State<SequenceLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentFrame = 0;

  static const List<String> _frames = [
    'assets/images/tile000.png',
    'assets/images/tile001.png',
    'assets/images/tile002.png',
    'assets/images/tile003.png',
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: Duration(
              milliseconds:
                  widget.frameDuration.inMilliseconds * _frames.length,
            ),
          )
          ..addListener(() {
            final frame =
                (_controller.value * _frames.length).floor() % _frames.length;
            if (frame != _currentFrame) {
              setState(() => _currentFrame = frame);
            }
          })
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        _frames[_currentFrame],
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        // Disable gapless playback for smoother sprite animation
        gaplessPlayback: true,
      ),
    );
  }
}

/// A shimmer loading placeholder widget
class ShimmerPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey[300]?.withOpacity(_animation.value),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}

/// Loading placeholder for list items
class ListItemPlaceholder extends StatelessWidget {
  const ListItemPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShimmerPlaceholder(
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerPlaceholder(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      ShimmerPlaceholder(
                        width: 150,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ShimmerPlaceholder(
              width: double.infinity,
              height: 12,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            ShimmerPlaceholder(
              width: double.infinity,
              height: 12,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
