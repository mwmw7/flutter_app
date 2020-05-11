import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:math' as math;


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "TABATA",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title : new Text("Home Page"),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new TextField(
              controller: _textController,
            )
          ),
          new ListTile(
            title: new RaisedButton(
                child: new Text("Next"),
                onPressed: (){
                  var route = new MaterialPageRoute(builder: (BuildContext context) => new NextPage(value: _textController.text));
                  Navigator.of(context).push(route);

            })
          )
        ],
      )
    );
  }
}

class NextPage extends StatefulWidget {
  String value;
  NextPage({Key key, this.value}):  super (key: key);
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> with TickerProviderStateMixin{
  AnimationController controller;
  int sec =0;
  // bool isPlaying = false;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    print(widget.value);
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: int.parse(widget.value)),
    );

    // ..addStatusListener((status) {
    //     if (controller.status == AnimationStatus.dismissed) {
    //       setState(() => isPlaying = false);
    //     }

    //     print(status);
    //   })
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Timer"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                                painter: TimerPainter(
                                  animation: controller,
                                  backgroundColor: Colors.white,
                                  color: themeData.indicatorColor,
                                ));
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "10min/10 workout",
                              style: themeData.textTheme.subhead,
                            ),
                            Text(
                                "${widget.value}s workout / 20s rest"
                            ),
//                            NumberPicker.integer(
//                              initialValue: sec,
//                              minValue: 0,
//                              maxValue: 23,
//                              listViewWidth: 60,
//                              onChanged: (val){
//                                setState(() {
//                                  sec = val;
//                                  debugPrint(sec.toString());
//                                });
//
//                              },
//
//                            ),
                            AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, Widget child) {
                                  return Text(
                                    timerString,
                                    style: themeData.textTheme.display4,
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child) {
                        return Icon(controller.isAnimating
                            ? Icons.pause
                            : Icons.play_arrow);

                        // Icon(isPlaying
                        // ? Icons.pause
                        // : Icons.play_arrow);
                      },
                    ),
                    onPressed: () {
                      // setState(() => isPlaying = !isPlaying);

                      if (controller.isAnimating) {
                        controller.stop(canceled: true);
                      } else {
                        controller.reverse(
                            from: controller.value == 0.0
                                ? 1.0
                                : controller.value);
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}


