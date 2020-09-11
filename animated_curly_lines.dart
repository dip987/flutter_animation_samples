import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 5));
    _controller.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedLine(_controller)
    );
  }
}


class AnimatedLine extends StatefulWidget {
  final AnimationController controller;

  AnimatedLine(this.controller);

  @override
  _AnimatedLineState createState() => _AnimatedLineState();
}

class _AnimatedLineState extends State<AnimatedLine> {
  AnimationController _controller;
  double _progress;


  @override
  void initState() {
    _progress = 0.0;
    _controller = widget.controller;
    _controller.addListener(() {
      setState(() {
        _progress = _controller.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TestPainter(_progress),
      child: Container(),
    );
  }
}


class TestPainter extends CustomPainter {
  double progress;

  TestPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    var lineSize = size.width - 60;
    var paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    var path = Path()
      ..moveTo(5.0, size.height / 2)
      ..lineTo((size.width - 55) * progress.animatedInRange(0.0, 0.2), size.height / 2)
      ..addArc(Rect.fromLTWH(size.width - 105, size.height / 2, 100, 100), -pi / 2,
          pi * progress.animatedInRange(0.2, 0.8))
      ..relativeLineTo(-lineSize*progress.animatedInRange(0.8, 1.0), 0.0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TestPainter oldDelegate) {
    return this.progress != oldDelegate.progress;
  }
}


extension RangeExtention on double{
  ///Makes an animation(double) go from zero to one while the given value is between the bound
  ///If the number is smaller than the lower range, return zero; if its greater than the upper range,
  ///return 1 otherwise return (original value - lower range) scaled between upper and lower range
  double animatedInRange(double lowerRange, double upperRange){
    if (this < lowerRange) return 0.0;
    else if (this > upperRange) return 1.0;
    else return (this - lowerRange)/(upperRange - lowerRange);
  }

}
