import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:math' as math;

void main() => runApp(new MyApp());

class WorkTime {
  int id;
  int seconds;

  WorkTime(this.id, this.seconds);

  static List<WorkTime> getWorkTimes() {
    return <WorkTime>[
        WorkTime(1, 5),
        WorkTime(2, 10),
    ];
  }

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "TABATA",
      theme: ThemeData.dark(),
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
    final formkey = new GlobalKey<FormState>();
    var rounds;
    var work_sec;
    var rest_sec;

    @override
    void dispose(){
      super.dispose();
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Home Page"),
        ),
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
              child: new Form(
                  key: formkey,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                              alignment: Alignment.center,
                              child: Text("TABATA",
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 75.0)))),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new ListTile(
                            title: new TextFormField(
                              validator: (val) => val.isEmpty ? "Invalid round": null,
                              onSaved: (val)=> rounds = val,
                              controller: _textController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.repeat),
                                  labelText: "Rounds",
                                  hintText: "4",
                                  labelStyle:
                                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                  suffixText: "rounds",
                                  suffixStyle: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.greenAccent),
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  filled: true,
                                  fillColor: Colors.black12),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new ListTile(
                            title: new TextFormField(
                              validator: (val) => val.isEmpty ? "Invalid work seconds": null,
                              onSaved: (val)=> work_sec = val,
                              controller: _textController2,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.access_alarm),
                                  labelText: "Work",
                                  labelStyle:
                                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                  suffixText: "seconds",
                                  suffixStyle: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.greenAccent),
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  hintText: "30",
                                  filled: true,
                                  fillColor: Colors.black12),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new ListTile(
                            title: new TextFormField(
                              validator: (val) => val.isEmpty ? "Invalid rest seconds": null,
                              onSaved: (val)=> rest_sec = val,
                              controller: _textController3,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.access_alarm),
                                  hintText: "10",
                                  labelText: "Rest",
                                  labelStyle:
                                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                  suffixText: "seconds",
                                  suffixStyle: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.greenAccent),
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  filled: true,
                                  fillColor: Colors.black12),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new ListTile(
                            title: new RaisedButton(
                                child: new Text("Next",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                color: Colors.blue,
                                splashColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                padding: const EdgeInsets.all(20.0),
                                onPressed: () {
                                  final form = formkey.currentState;
                                  if(form.validate()){
                                    form.save();
                                    var route = new MaterialPageRoute(
                                        builder: (BuildContext context) => new NextPage(
                                            value: work_sec,
                                            rest: rest_sec,
                                            round: rounds));
                                    Navigator.of(context).push(route);
                                  }

                                })),
                      )
                    ],
                  )),
            )));
  }
}

class NextPage extends StatefulWidget {
  String value;
  String rest ;
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
  int round_int;
  int sec = 0;
  int beforeWorkSeconds = 0;
  int beforeRestSeconds = 0;

  // bool isPlaying = false;

  String get timerString {
    print("Duration : " + controller.duration.toString());
    print("Value : " + controller.value.toString());
    print("inMinutes : " + controller.duration.inMinutes.toString());
    print("inSeconds : " + (controller.duration.inSeconds % 60).toString());

    Duration duration = controller.duration * (controller.value);

    var timerString;
    var worksSeconds;
    if(controller.value == 0.0){
      timerString = '${duration.inMinutes}:${(controller.duration.inSeconds).toString().padLeft(2, '0')}';
    }else{
      if(beforeWorkSeconds < duration.inSeconds % 60 + 1){
        worksSeconds = beforeWorkSeconds;
      }else{
        worksSeconds = duration.inSeconds % 60 + 1;
      }
      print("worksSeconds : " + worksSeconds.toString());
      timerString = '${duration.inMinutes}:${worksSeconds.toString().padLeft(2, '0')}';
    }
    beforeWorkSeconds = controller.duration.inSeconds;
    return timerString;
  }
  String get timerStringForRest {
    var restSeconds;

    Duration duration = controller2.duration * (controller2.value);
    var timerString;
    if(controller2.value == 0.0){
      timerString = '${duration.inMinutes}:${(controller2.duration.inSeconds).toString().padLeft(2, '0')}';
    }else{
      if(beforeRestSeconds < duration.inSeconds % 60 + 1){
        restSeconds = beforeRestSeconds;
      }else{
        restSeconds = duration.inSeconds % 60 + 1;
      }
      print("restSeconds : " + restSeconds.toString());
      timerString = '${duration.inMinutes}:${restSeconds.toString().padLeft(2, '0')}';
    }

    beforeRestSeconds = controller2.duration.inSeconds;
    return timerString;
  }

  @override
  void initState() {
    super.initState();

    print(widget.value);
    print(widget.rest);

    round_int = int.parse(widget.round);

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
        if(round_int > 1){
          round_int--;
          controller.reverse(
              from: controller.value == 0.0 ? 1.0 : controller.value);
        }
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
                              "${round_int} / ${widget.round} rounds",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "${widget.value}s workout / ${widget.rest}s rest"),
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
                                  color: Colors.lightBlueAccent,
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
                              "Rest",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
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
                                    timerStringForRest,
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
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
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
