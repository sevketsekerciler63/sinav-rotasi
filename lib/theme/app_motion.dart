import 'package:flutter/material.dart';

/// Motion never owns persistence, task identity, or timer state.
abstract final class AppMotion {
  static const press = Duration(milliseconds: 120);
  static const standard = Duration(milliseconds: 180);
  static const progress = Duration(milliseconds: 240);
  static const curve = Curves.easeOutCubic;
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ??
      WidgetsBinding
          .instance
          .platformDispatcher
          .accessibilityFeatures
          .disableAnimations;
  static Duration duration(BuildContext context, Duration normal) =>
      reduced(context) ? Duration.zero : normal;
}

/// Keep Flutter's platform navigation/back behavior and honor reduced motion.
class AppPageRoute<T> extends MaterialPageRoute<T> {
  AppPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
  });
  @override
  Duration get transitionDuration => navigator == null
      ? AppMotion.standard
      : AppMotion.duration(navigator!.context, AppMotion.standard);
  @override
  Duration get reverseTransitionDuration => transitionDuration;
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => AppMotion.reduced(context)
      ? child
      : super.buildTransitions(context, animation, secondaryAnimation, child);
}
