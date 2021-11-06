

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate_monitor/home_screen.dart';

//About Page
class HistoryPage extends StatelessWidget {

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
                                Text('History', style: TextStyle(fontFamily: 'Montserrat Medium', color: Colors.white, fontSize: 28)),
                              ]
                          )
                        ]
                    )
                  ),
                      Spacer(),
                      Container(
                        constraints: BoxConstraints(minHeight: 50.0),
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(0.0, 1.0);
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