import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flip_panel/flip_panel.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Circle Clock',
      theme: ThemeData(
        textTheme: GoogleFonts.fugazOneTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: '#3b4252'.toColor(),
        appBar: AppBar(
            title: Text("Circle Clock",
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                      color: '#eceff4'.toColor(),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0),
                )),
            backgroundColor: '#2e3440'.toColor(),
            centerTitle: true),
        body: new HomeContent());
  }
}

class HomeContent extends StatefulWidget {
  HomeContent({Key key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  double degree;
  double newDegree;
  AnimationController degreeAnimationController;

  @override
  void initState() {
    super.initState();
    setState(() {
      degree = 6.0 * DateTime.now().second;
      newDegree = 6.0 * DateTime.now().second;
    });

    degreeAnimationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1))
      ..addListener(() {
        setState(() {
          degree =
              lerpDouble(degree, newDegree, degreeAnimationController.value);
        });
      });

    Timer.periodic(Duration(seconds: 1), (timer) {
      _onPressed();
    });
  }

  void _onPressed() {
    setState(() {
      degree = newDegree;
      newDegree += 6;
      if (newDegree >= 360.0 || DateTime.now().second == 0) {
        degree = 0.0;
        newDegree = 0.0;
      }
      degreeAnimationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SizedBox(
                  width: 300.0,
                  child: FadeAnimatedTextKit(
                    key: Key('mmdd'),
                    displayFullTextOnTap: true,
                    duration: Duration(seconds: 60),
                    text: [_getMmdd()],
                    textStyle: TextStyle(
                        color: '#4c566a'.toColor(),
                        fontSize: 64.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cabin'),
                    textAlign: TextAlign.center,
                    alignment: AlignmentDirectional.topStart,
                    totalRepeatCount: 10,
                  ),
                )),
            onPressed: () {},
          ),
          Center(
            child: Container(
              height: 340.0,
              width: 340.0,
              child: CustomPaint(
                foregroundPainter: MyPainter(
                    lineColor: '#5e81ac'.toColor(),
                    completeColor: '#bf616a'.toColor(),
                    completeDegree: degree,
                    width: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    elevation: 16.0,
                    color: '#81a1c1'.toColor(),
                    splashColor: '#88c0d0'.toColor(),
                    shape: CircleBorder(),
                    child: Center(
                      child: SizedBox(
                          height: 64.0,
                          child: FlipClock.simple(
                            startTime: DateTime.now(),
                            digitColor: '#2e3440'.toColor(),
                            backgroundColor: '#d8dee9'.toColor(),
                            digitSize: 42.0,
                            width: 36.0,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3.0)),
                            flipDirection: FlipDirection.up,
                          )),
                    ),
                    onPressed: _onPressed,
                  ),
                ),
              ),
            ),
          ),
          FlatButton(
            child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: 300.0,
                  child: TextLiquidFill(
                    key: Key('today'),
                    text: _getToday(),
                    loadDuration: Duration(seconds: 60),
                    waveColor: '#4c566a'.toColor(),
                    boxBackgroundColor: '#3b4252'.toColor(),
                    textStyle: TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Oswald',
                        fontStyle: FontStyle.italic),
                    boxHeight: 80.0,
                  ),
                )),
            onPressed: () {},
          ),
        ]);
  }

  String _getMmdd() {
    return DateTime.now().month.toString() +
        ' ' +
        DateTime.now().day.toString();
  }

  String _getToday() {
    return DateFormat('EEEE').format(DateTime.now());
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completeDegree;
  double width;
  MyPainter(
      {this.lineColor, this.completeColor, this.completeDegree, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - width / 2;
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completeDegree / 360);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
