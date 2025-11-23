import 'package:flutter/material.dart';

enum ConnectionStatus {
  connected,
  disconnected,
  connecting,
}

class StatusIndicator extends StatefulWidget {
  final ConnectionStatus status;
  final String? statusText;

  const StatusIndicator({
    Key? key,
    required this.status,
    this.statusText,
  }) : super(key: key);

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    switch (widget.status) {
      case ConnectionStatus.connected:
        return Colors.green;
      case ConnectionStatus.disconnected:
        return Colors.red;
      case ConnectionStatus.connecting:
        return Colors.orange;
    }
  }

  String _getStatusText() {
    if (widget.statusText != null) return widget.statusText!;
    
    switch (widget.status) {
      case ConnectionStatus.connected:
        return 'Connected';
      case ConnectionStatus.disconnected:
        return 'Not Connected';
      case ConnectionStatus.connecting:
        return 'Connecting...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final text = _getStatusText();
    final isAnimated = widget.status == ConnectionStatus.connecting;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated dot for connecting state
        isAnimated
            ? AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: widget.status == ConnectionStatus.connected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
