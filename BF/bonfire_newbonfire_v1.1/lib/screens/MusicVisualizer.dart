import 'package:flutter/material.dart';

class MusicVisualizer extends StatelessWidget {
  int numBars;
  double barHeight;

  MusicVisualizer({this.numBars, this.barHeight});

  List<Color> colors = [
    Colors.deepOrangeAccent,
    Colors.orange,
    Colors.amber,
    Colors.amber
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
          color: colors[index % 4],
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

  VisualComponent({this.duration, this.color, this.barHeight});

  @override
  _VisualComponentState createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

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
