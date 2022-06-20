import 'package:simple_animations/multi_tween/multi_tween.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/stateless_animation/play_animation.dart';


class FadeX extends StatelessWidget {
  final double delay;
  final Widget? child;
  final bool? reversed ;

  FadeX({required this.delay, this.child, this.reversed});

  @override
  Widget build(BuildContext context) {
    bool reverse = reversed ?? false ;

    final tween = MultiTween<_AniProps>()
      ..add(_AniProps.opacity, Tween<double>(begin: 0.5, end: 1.0))
      ..add(_AniProps.secondry, Tween<double>(begin: .97, end: 1.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: Duration(milliseconds: (250 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset(0.0, reverse ? -animation.get(_AniProps.opacity) : animation.get(_AniProps.secondry)),
          child: child,
        ),
      ),
    );
  }
}
class FadeY extends StatelessWidget {
  final double? delay;
  final Widget? child;
  final bool? reversed ;

  FadeY({this.delay, this.child, this.reversed});

  @override
  Widget build(BuildContext context) {
    bool reverse = reversed ?? false ;

    final tween = MultiTween<_AniProps>()
      ..add(_AniProps.opacity, Tween<double>(begin: 0.5, end: 1.0))
      ..add(_AniProps.secondry, Tween<double>(begin:  .97, end: 1.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: Duration(milliseconds: (250 * delay!).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset( 0.0,reverse ? -animation.get(_AniProps.opacity) :  animation.get(_AniProps.secondry) ),
          child: child,
        ),
      ),
    );
  }
}


enum _AniProps { opacity, secondry }

class FadeScale extends StatelessWidget {
  final Widget? child;
  final int? delay;
  final double? scale;
  final int? duration;
  final Curve? curve;

  const FadeScale({ this.delay, this.child, this.scale, this.duration, this.curve});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()
      ..add(_AniProps.opacity, Tween<double>(begin: 0.5, end: 1.0))
      ..add(_AniProps.secondry, Tween<double>(begin: scale ?? .97, end: 1.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      duration: Duration(milliseconds: duration ?? 350),
      tween: tween,
      curve: curve ?? Curves.easeOutCubic,
      delay: Duration(milliseconds: delay ?? 0),
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.scale(
          scale: value.get(_AniProps.secondry),
          child: child,
        ),
      ),
      child: child,
    );
  }
}



