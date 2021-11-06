
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate_monitor/about_page.dart';
import 'package:heart_rate_monitor/help_page.dart';
import 'package:heart_rate_monitor/history_page.dart';
import 'package:heart_rate_monitor/measure_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    //to get size
    var size = MediaQuery.of(context).size;

    //style
    var cardTextStyle = TextStyle(
        fontFamily: 'Montserrat Regular',
        fontSize: 14,
        color: Color.fromRGBO(63, 63, 63, 1));

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
                                        Text('Heart Rate Monitor', style: TextStyle(fontFamily: 'Montserrat Medium', color: Colors.white, fontSize: 28)),
                                      ]
                                  )
                                ]
                            )
                        ),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2.4,
                            primary: false,
                            children: <Widget>[
                              //Measure card
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                elevation: 4,
                                child: new InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => MeasurePage(),
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('assets/images/heart.png', height: 100,),
                                      Text('Measure', style: cardTextStyle)
                                    ],
                                  ),
                                ),
                              ),

                              //Help card
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                elevation: 4,
                                child: new InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => HelpPage(),
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('assets/images/instructions.png', height: 100,),
                                      Text('Help', style: cardTextStyle)
                                    ],
                                  ),
                                )
                              ),

                              //List card
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                elevation: 4,
                                child: new InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => HistoryPage(),
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('assets/images/list.png', height: 100,),
                                      Text('History', style: cardTextStyle)
                                    ],
                                  ),
                                )
                              ),

                              //About us card
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                elevation: 4,
                                child: new InkWell(
                                onTap: () {
                                   Navigator.of(context)
                                      .push(PageRouteBuilder(
                                       pageBuilder: (context, animation, secondaryAnimation) => AboutPage(),
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('assets/images/editor.png', height: 100,),
                                      Text('About us', style: cardTextStyle)
                                    ],
                                  ),
                                )
                              ),

                            ],
                          ),
                        )
                      ],
                  ),
              ),
          ),

        ],
      )
    );
  }
}

Route _createRoute(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page(),
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
  );
}