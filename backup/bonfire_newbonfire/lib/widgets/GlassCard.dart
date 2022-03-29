import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double start;
  final double end;
  final double height;
  final double width;

  const GlassCard({
    this.child,
    this.start,
    this.end,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          height: 200,
          width: 600,
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/images/SF.jpg")),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).backgroundColor.withOpacity(start),
                Theme.of(context).indicatorColor.withOpacity(end),
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1.5,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }
}
