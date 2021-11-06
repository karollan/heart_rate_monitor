

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate_monitor/home_screen.dart';

//About Page
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //to get size
    var size = MediaQuery.of(context).size;

    //style
    var cardTextStyle = TextStyle(
        fontFamily: 'Montserrat Medium',
        fontSize: 18,
        color: Color.fromRGBO(63, 63, 63, 1));

    return Scaffold(
      body: Stack(
        children: <Widget> [
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
                                  Text('About us', style: TextStyle(fontFamily: 'Montserrat Medium', color: Colors.white, fontSize: 28)),
                                ]
                            )
                          ]
                      )
                  ),

                  Stack(
                    children: <Widget>[
                      Card(
                        margin: const EdgeInsets.only(top: 20.0),
                        elevation: 4,
                        child: SizedBox(
                            height: 200.0,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Foo",
                                  ),
                                  Text("bar")
                                ],
                              ),
                            )),
                      ),

                      Positioned(
                        top: .0,
                        left: 0.0,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, .0, .0, .0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 48.0,
                                    backgroundImage: NetworkImage('https://github.com/AgnieszkaCybulska.png'),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Agnieszka Cybulska", style: cardTextStyle)
                                      ]
                                  )
                                ]
                            )
                          )
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Stack(

                    children: <Widget>[
                      Card(
                        margin: const EdgeInsets.only(top: 20.0),
                        elevation: 4,
                        child: SizedBox(
                            height: 200.0,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 45.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Foo",
                                  ),
                                  Text("bar")
                                ],
                              ),
                            )),
                      ),

                      Positioned(
                        top: .0,
                        left: 0.0,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.0, .0, .0, .0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 48.0,
                                backgroundImage: NetworkImage('https://github.com/karollan.png'),
                              ),
                              SizedBox(width: 20),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Karol Lange", style: cardTextStyle)
                                  ]
                              )
                            ]
                          )

                        ),
                      )
                    ],
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
                ],
              ),
            ),
          ),
        ]
      )
    );
  }
}
