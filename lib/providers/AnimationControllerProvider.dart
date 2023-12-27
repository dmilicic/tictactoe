import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class AnimationControllerProvider extends InheritedWidget {
  final AnimationController controller;

  const AnimationControllerProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  static AnimationControllerProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AnimationControllerProvider>();
  }

  @override
  bool updateShouldNotify(AnimationControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}