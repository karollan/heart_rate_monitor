

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate_monitor/home_screen.dart';
import 'package:heart_rate_monitor/models/measure.dart';


//About Page
class MeasurePage extends StatelessWidget {

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
                              constraints: BoxConstraints(minHeight: 270.0, minWidth: 270),
                              margin: EdgeInsets.all(10),
                              child: ElevatedButton(
                                //Measure START
                                onPressed: () async {
                                  //Make singleton
                                  var databaseHelper = DatabaseHelper();
                                  //Create data
                                  Random rand = Random();
                                  int result = rand.nextInt(100);
                                  Measure measure = Measure(result: result.toString(), date: '12.03.2021 13:54', img: 'heart.png', graph: 'graph');
                                  //insert data
                                  await databaseHelper.insertMeasure(measure);
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
                                          'TAP HERE TO START',
                                          style: TextStyle(
                                              fontSize: 20,
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
                              child: Text("GRAPH"),
                            ),

                            Container(
                              constraints: BoxConstraints(minHeight: 50.0),
                              margin: EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
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