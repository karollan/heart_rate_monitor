import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heart_rate_monitor/home_screen.dart';
import 'package:heart_rate_monitor/models/measure.dart';
import 'package:camera/camera.dart';
import 'package:wakelock/wakelock.dart';
import 'package:heart_rate_monitor/models/Chart.dart';
import 'package:collection/collection.dart';

import 'models/Utils.dart';

//About Page
class MeasurePage extends StatefulWidget {
  @override
  MeasurePageView createState() => MeasurePageView();
}

class MeasurePageView extends State<MeasurePage> {
  bool _toggled = false; // toggle button value
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
  String? _score;
  bool _isFinished = false;

  final _chartKey = GlobalKey();
  Uint8List? _chartImage;

  int _timeToStartCounter = 5;
  Timer? _timerBeforeStart;

  @override
  void dispose() {
    _timerBeforeStart?.cancel();
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
    _initController().then((onValue) {
      setState(() {
        _toggled = true;
        _timeToStartCounter = 5;
        _isFinished = false;
      });
      _timerBeforeStart = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_timeToStartCounter == 0) {
          _clearData();
          Wakelock.enable();
          setState(() {
            _timerBeforeStart!.cancel();
            _isFinished = true;
          });
            // after is toggled
            this._timerCountdown = 1000*_fs;
            _initTimer();
            _updateBPM();
        } else {
          setState(() {
            _timeToStartCounter--;
          });
        }
    });
      });
  }

  void _untoggle() async {
    _disposeController();
    Wakelock.disable();
    setState(() {
      _timeToStartCounter = 5;
      _toggled = false;
      _timerBeforeStart!.cancel();
    });

    if (_timerCountdown! <= 0) {
      //Make image of chart
      Uint8List image = await Utils.capture(_chartKey);
      setState(() {
        _chartImage = image;
        _score = _bpmList.average.floor().toString();
      });
      _isFinished = true;
      _addToDatabase();
    }
  }

  _addToDatabase() async {
      var databaseHelper = DatabaseHelper();
      DateTime _dateTime = DateTime(_now!.year, _now!.month, _now!.day, _now!.hour, _now!.minute);
      String _formatDate = (DateFormat('yyyy-MM-dd HH:mm:ss').format(_dateTime)).toString();
      Measure measure = Measure(result: _score as String, date: _formatDate, img: 'heart.png', graph: _chartImage as Uint8List);
      await databaseHelper.insertMeasure(measure);
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

      if (_timerCountdown == 0) {
        timer.cancel();
        _untoggle();
      } else
      {
        setState(() {
          _timerCountdown = _timerCountdown! - _fs;
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
          //if (this._bpm > 30 && this._bpm < 150) {
            _bpmList.add(this._bpm);
          //}
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
        //Zdjecie i widok z kamery
        body: Stack(
            children: <Widget>[
              _controller != null && _toggled
                  ? AspectRatio(
                aspectRatio:
                _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              )
                  : Container(
                height: size.height * .3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/images/top_header.png')
                  ),
                ),
              ),

              //Napis measure i Camera feed coś tam
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
                                            Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                  _toggled
                                                      ? "Cover the camera and the flash with your finger"
                                                      : "Camera feed will display here",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Montserrat Medium',
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                )),
                                          ]
                                      )
                                    ]
                                )
                            ),

                            // Guzik do rozpoczecia pomiaru, onPressed funkcja po kliknieciu
                            Container(
                              constraints: BoxConstraints(minHeight: size.height*.3, minWidth: size.height*.3),
                              margin: EdgeInsets.all(10),
                              child: ElevatedButton(
                                //Measure START
                                onPressed: () {

                                  //Create data

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
                                          _isFinished ? (!_toggled ? "${_score!} BPM" : 'MEASUREMENT') : 'TAP TO START',
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

                            _toggled && _timeToStartCounter > 0 ? Text('${_timeToStartCounter}s to start') : SizedBox(),

                            // Wykres
                            Expanded(
                                    child: RepaintBoundary(
                                        key: _chartKey,
                                        child: Chart(_data))
                            ),


                            //Tekst z odliczaniem
                            _toggled && (_timerCountdown != null && _timeToStartCounter <= 0) ? Text('${((_timerCountdown!/1000).round()).toString()}s to finish.') : SizedBox(),

                            //Guzik do powrotu na glowna strone
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