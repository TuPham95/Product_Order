import 'package:flutter/material.dart';

class SkeletonPulse extends StatefulWidget {
  final Widget child;

  const SkeletonPulse({Key? key, required this.child}) : super(key: key);

  @override
  State<SkeletonPulse> createState() => _SkeletonPulseState();
}

class _SkeletonPulseState extends State<SkeletonPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.55,
      upperBound: 1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _controller, child: widget.child);
  }
}

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  final EdgeInsetsGeometry? margin;

  const SkeletonBox({
    Key? key,
    this.width,
    required this.height,
    this.radius = 12,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: const Color(0xFFDCE5EA),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
