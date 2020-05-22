import 'package:flutter/material.dart';

/// Custom [MaterialPageRoute] without animation
///
/// Simply navigates to another page, without animation
class NonAnimatedPageRoute<T> extends MaterialPageRoute<T> {
  NonAnimatedPageRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
