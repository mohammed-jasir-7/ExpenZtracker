import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  CustomPageRoute({required this.child})
      : super(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (context, animation, secondaryanimation) => child);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var tween =
        Tween<Offset>(begin: const Offset(0, 2), end: const Offset(0, 0))
            .chain(CurveTween(curve: Curves.easeInOut));
    return SlideTransition(
      position: tween.animate(animation),
      child: child,
    );
  }
}
