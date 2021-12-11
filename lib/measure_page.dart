
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heart_rate_monitor/home_screen.dart';
import 'package:heart_rate_monitor/models/measure.dart';
import 'package:camera/camera.dart';
import 'package:wakelock/wakelock.dart';
import 'package:heart_rate_monitor/models/Chart.dart';
import 'package:collection/collection.dart';

//About Page
class MeasurePage extends StatefulWidget {

  @override
  MeasurePageView createState() => MeasurePageView();
}

// TODO Duzo bledow, trzeba ustawic timer zeby liczyl tylko 30s
//  Naprawic date (pokazuje milisekundy w wyniku)
//

class MeasurePageView extends State<MeasurePage> {
  bool _toggled = false; // toggle button value
  bool _fingerOnCamera = false;
  List<SensorValue> _data = <SensorValue>[]; // array to store the values
  CameraController? _controller;
  double _alpha = 0.3; // factor for the mean value
  int _bpm = 0; // beats per minute
  int _fs = 30; // sampling frequency (fps)
  int _windowLen = 30 * 6; // window length to display - 6 seconds
  CameraImage? _image; // store the last camera image
  double _avg = 0;// store the average value during calculation
  DateTime? _now; // store the now Datetime
  Timer? _timer; // timer for image processing
  int? _timerCountdown;
  List<int> _bpmList = <int>[];

  @override
  void dispose() {
    _timer?.cancel();
    _toggled = false;
    _disposeController();
    Wakelock.disable();
    super.dispose();
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++)
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
  }

  void _toggle() {
    _clearData();
    _initController().then((onValue) {
      Wakelock.enable();
      setState(() {
        _toggled = true;
      });
      // after is toggled
      this._timerCountdown = 1000*_fs;
      _initTimer();
      _updateBPM();
    });
  }

  void _untoggle() async {
    _disposeController();
    Wakelock.disable();
    //Make singleton
    var databaseHelper = DatabaseHelper();
    Measure measure = Measure(result: _bpmList.average.floor().toString(), date: DateTime(_now!.year, _now!.month, _now!.day, _now!.hour, _now!.minute).toString(), img: 'heart.png', graph: 'graph');
    //insert data
    await databaseHelper.insertMeasure(measure);
    setState(() {
      _toggled = false;
    });
  }

  void _disposeController() {
    _controller?.dispose();
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);
      await _controller?.initialize();
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
        _controller?.setFlashMode(FlashMode.torch);
      });
      _controller?.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (Exception) {
      print(Exception);
    }
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) _scanImage(_image!);
      } else  {
        timer.cancel();
      }
      //  TODO CZY TO DZIALA TO NIE WIEM CHODZI O TO ZE PO 30S MA SIE WYLACZYC
      if (_timerCountdown == 0) {
        timer.cancel();
        _untoggle();
      } else
      {
        setState(() {
          _timerCountdown = _timerCountdown! - _fs;
          print(_timerCountdown);
        });
      }
    });
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _fingerOnCamera = true;
      _data.add(SensorValue(_now!, 255 - _avg));
    });
  }

  _updateBPM() async {
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _bpm;
    double _threshold;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data);
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        print(_bpm);
        setState(() {
          this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
          if (this._bpm > 30 && this._bpm < 150) {
            _bpmList.add(this._bpm);
          }
        });
      }
      await Future.delayed(Duration(
          milliseconds:
          1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }
  }

  @override
  Widget build(BuildContext context) {

    //get size
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
            children: <Widget>[
              Container(
                height: size.height * .3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/images/top_header.png')
                  ),
                ),
              ),

              SafeArea(
                  child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                                height: 64,
                                margin: EdgeInsets.only(bottom: 20),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('Measure', style: TextStyle(fontFamily: 'Montserrat Medium', color: Colors.white, fontSize: 28)),
                                          ]
                                      )
                                    ]
                                )
                            ),

                            Container(
                              constraints: BoxConstraints(minHeight: size.height*.3, minWidth: size.height*.3),
                              margin: EdgeInsets.all(10),
                              child: ElevatedButton(
                                //Measure START
                                onPressed: () {

                                  //Create data

                                  // TODO: Ma być 30s pomiaru, 5s czekania przed rozpoczęciem
                                  if (_toggled) {
                                    _untoggle();
                                  } else {
                                    _toggle();
                                  }

                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 6,
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(20.0),
                                  primary: Colors.red,
                                  onPrimary: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          _toggled ? (_bpm > 30 && _bpm < 150 ? _bpm.toString() : "--") :
                                          'TAP TO START',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: 'Montserrat Regular'
                                          ),
                                        ),
                                        SizedBox(height: 30,),
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                          size: 64,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            Expanded(
                              child: Chart(_data),
                            ),
                            //  TODO TUTAJ MA BYC NAPIS PO KLIKNIECIU ZEBY ZASLONIC KAMERE A POTEM ODLICZANIE OD 30
                            Text(_fingerOnCamera ? (_toggled ? "${(_timerCountdown!/1000).toString()} to finish." : 'Cover the camera with your finger!') : ''),
                            Container(
                              constraints: BoxConstraints(minHeight: 50.0),
                              margin: EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
                                  _disposeController();
                                  Wakelock.disable();
                                  _toggled = false;
                                  Navigator.of(context)
                                      .push(PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(-1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(begin: begin, end:end).chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      }
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  onPrimary: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Go back',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontFamily: 'Montserrat Regular'
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ]
                      )
                  )
              )

            ]
        )
    );
  }
}