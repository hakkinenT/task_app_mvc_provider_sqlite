import 'package:flutter/material.dart';

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;
  final String? routeName;

  SlideUpRoute({required this.page, this.routeName, super.fullscreenDialog})
      : super(
            settings: RouteSettings(name: routeName),
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                page,
            transitionDuration: const Duration(milliseconds: 450),
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0.0, 1.0), end: Offset.zero)
                      .animate(animation),
                  child: child,
                ));
}
