import 'package:flutter/material.dart';

class HeartbeatProgressIndicator extends StatefulWidget {
  final Duration duration;
  final double startScale;
  final double endScale;
  final Widget child;

  HeartbeatProgressIndicator({
    Duration duration,
    this.startScale: 1.0,
    this.endScale: 2.0,
    @required this.child,
  })  : this.duration = duration ?? Duration(milliseconds: 1000),
        assert(child != null);

  @override
  _HeartbeatProgressIndicatorState createState() =>
      _HeartbeatProgressIndicatorState();
}

class _HeartbeatProgressIndicatorState extends State<HeartbeatProgressIndicator>
    with TickerProviderStateMixin {
  Animation animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = _createOscillatingAnimationController(widget.duration, this);
    animation = _createTweenAnimation(
      controller,
      begin: widget.startScale,
      end: widget.endScale,
      curve: Curves.elasticOut,
    );
    controller.forward();
  }

  @override
  Widget build(BuildContext context) =>
      ScaleTransition(scale: animation, child: widget.child);

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class GlowingProgressIndicator extends StatefulWidget {
  final Duration duration;
  final Widget child;

  GlowingProgressIndicator({
    Duration duration,
    @required this.child,
  })  : this.duration = duration ?? Duration(milliseconds: 1000),
        assert(child != null);

  @override
  _GlowingProgressIndicatorState createState() =>
      _GlowingProgressIndicatorState();
}

class _GlowingProgressIndicatorState extends State<GlowingProgressIndicator>
    with TickerProviderStateMixin {
  Animation animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = _createOscillatingAnimationController(widget.duration, this);
    animation = _createTweenAnimation(
      controller,
      begin: 0.0,
      end: 1.0,
      curve: Curves.easeOut,
    );
    controller.forward();
  }

  @override
  Widget build(BuildContext context) =>
      FadeTransition(opacity: animation, child: widget.child);

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

AnimationController _createOscillatingAnimationController(
  Duration duration,
  TickerProvider provider,
) {
  final AnimationController controller =
      AnimationController(duration: duration, vsync: provider);
  controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      controller.forward();
    }
  });
  return controller;
}

Animation _createTweenAnimation(
  AnimationController controller, {
  double begin: 1.0,
  double end: 2.0,
  Curve curve: Curves.easeOut,
}) {
  return Tween(begin: begin, end: end)
      .animate(CurvedAnimation(parent: controller, curve: curve));
}