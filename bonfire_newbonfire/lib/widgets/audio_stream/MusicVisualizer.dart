import 'package:flutter/material.dart';

class MusicVisualizer extends StatelessWidget {
  int numBars;
  double barHeight;

  MusicVisualizer({required this.numBars, required this.barHeight});

  List<Color> colors = [
    /*Colors.amber,
    Colors.amber,
    Colors.amber,
    Colors.amber,
    Colors.amber,
    Colors.amber,*/
    Colors.orange,
    Colors.orange,
    Colors.orange,
    Colors.orange,
    Colors.orange,
    Colors.orange,
    Colors.orange,
    Colors.orange,
    Colors.orange,
    Colors.orange,
    Colors.orange,
    Colors.orange
  ];
  List<int> duration = [900, 700, 600, 800, 500];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: new List<Widget>.generate(
        numBars,
        (index) => VisualComponent(
          duration: duration[index % 2],
          color: colors[index % 12],
          barHeight: barHeight,
        ),
      ),
    );
  }
}

class VisualComponent extends StatefulWidget {
  final int duration;
  final Color color;
  final double barHeight;

  VisualComponent({required this.duration, required this.color, required this.barHeight});

  @override
  _VisualComponentState createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );
    final curvedAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animation =
        Tween<double>(begin: 0, end: widget.barHeight).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
    animationController.repeat(reverse: true);
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4.5,
      height: animation.value,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
