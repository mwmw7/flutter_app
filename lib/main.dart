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
  var _textController2 = new TextEditingController();
  var _textController3 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Home Page"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
          child: new ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new ListTile(
                    title: new TextField(
                  controller: _textController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.greenAccent),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        hintText:"00:10",
                        filled:true,
                        fillColor: Colors.grey[200]
                      ),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new ListTile(
                    title: new TextField(
                  controller: _textController2,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          hintText:"00:10",
                          filled:true,
                          fillColor: Colors.grey[200]
                      ),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new ListTile(
                    title: new TextField(
                  controller: _textController3,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          hintText:"00:10",
                          filled:true,
                          fillColor: Colors.grey[200]
                      ),
                )),
              ),
              new ListTile(
                  title: new RaisedButton(
                      child: new Text("Next"),
                      onPressed: () {
                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) => new NextPage(
                                value: _textController.text,
                                rest: _textController2.text,
                                round: _textController3.text));
                        Navigator.of(context).push(route);
                      }))
            ],
          ),
        ));
  }
}

class NextPage extends StatefulWidget {
  String value;
  String rest;
  String round;

  bool isPlaying = false;

  bool isWork = true;

  NextPage({Key key, this.value, this.rest, this.round}) : super(key: key);

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> with TickerProviderStateMixin {
  AnimationController controller; //for workout
  AnimationController controller2; //for rest

  int sec = 0;

  // bool isPlaying = false;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();

    print(widget.value);
    print(widget.rest);

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: int.parse(widget.value)),
    );

    controller2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: int.parse(widget.rest)),
    );

    controller.addStatusListener((status) {
      if (controller.status == AnimationStatus.dismissed) {
        setState(() => widget.isWork = false);
        controller2.reverse(
            from: controller2.value == 0.0 ? 1.0 : controller2.value);
      }
      print("work : " + status.toString());
    });
    controller2.addStatusListener((status) {
      if (controller2.status == AnimationStatus.dismissed) {
        setState(() => widget.isWork = true);
      }
      print("rest : " + status.toString());
    });
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
            widget.isWork
                ? Expanded(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "${widget.round} rounds",
                                    style: themeData.textTheme.subhead,
                                  ),
                                  Text(
                                      "${widget.value}s workout / ${widget.rest} s rest"),
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
                                      builder:
                                          (BuildContext context, Widget child) {
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
                  )
                : Expanded(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: controller2,
                                builder: (BuildContext context, Widget child) {
                                  return CustomPaint(
                                      painter: TimerPainter(
                                    animation: controller2,
                                    backgroundColor: Colors.white,
                                    color: Colors.greenAccent,
                                  ));
                                },
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "10min/10 workout",
                                    style: themeData.textTheme.subhead,
                                  ),
                                  Text(
                                      "${widget.value}s workout / ${widget.rest} s rest"),
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
                                      animation: controller2,
                                      builder:
                                          (BuildContext context, Widget child) {
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
            widget.isWork
                ? Container(
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
                            setState(
                                () => widget.isPlaying = !widget.isPlaying);

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
                : Container(
                    margin: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FloatingActionButton(
                          child: AnimatedBuilder(
                            animation: controller2,
                            builder: (BuildContext context, Widget child) {
                              return Icon(controller2.isAnimating
                                  ? Icons.pause
                                  : Icons.play_arrow);

                              // Icon(isPlaying
                              // ? Icons.pause
                              // : Icons.play_arrow);
                            },
                          ),
                          onPressed: () {
                            setState(
                                () => widget.isPlaying = !widget.isPlaying);

                            if (controller2.isAnimating) {
                              controller2.stop(canceled: true);
                            } else {
                              controller2.reverse(
                                  from: controller2.value == 0.0
                                      ? 1.0
                                      : controller2.value);
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
