

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate_monitor/home_screen.dart';


//About Page
class HelpPage extends StatelessWidget {

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
                                            Text('Help', style: TextStyle(fontFamily: 'Montserrat Medium', color: Colors.white, fontSize: 28)),
                                          ]
                                      )
                                    ]
                                )
                            ),

                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset('assets/images/how_to_use.png')
                                  ),

                                ]
                              )
                            ),

                            Expanded(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 20),
                                          Text('How to measure my heart rate?', style: TextStyle(fontSize: 20, fontFamily: 'Montserrat Medium')),
                                          SizedBox(height: 10),
                                          Text('To measure your heart rate first place the tip of your index finger on the back of your device so that it covers'
                                              'both the camera and the flashlight. You can then start the measurement by tapping the circle at the center'
                                              'of the screen.', style: TextStyle(fontSize: 16, fontFamily: 'Montserrat Regular'), textAlign: TextAlign.justify,),
                                          SizedBox(height: 20),
                                          Text('WARNING', style: TextStyle(fontSize: 20, fontFamily: 'Montserrat Medium')),
                                          SizedBox(height: 10),
                                          Text('In some devices the flash can get very hot, please avoid touching it.',
                                            style: TextStyle(fontSize: 16, fontFamily: 'Montserrat Regular'), textAlign: TextAlign.justify,),
                                          SizedBox(height: 20),
                                          Text('Tips', style: TextStyle(fontSize: 20, fontFamily: 'Montserrat Medium')),
                                          SizedBox(height: 10),
                                          Text('Keep your finger as still as possible as even slight movements can disrupt the measurement. When the'
                                              'graph is showing a distinct steady pattern of peaks corresponding to your heart beats the measurement'
                                              'should be accurate. If the graph is noisy or very irregular you need to keep your finger more steady'
                                              'or possinly adjust the way you are holding your finger.', style: TextStyle(fontSize: 16, fontFamily: 'Montserrat Regular'), textAlign: TextAlign.justify,),
                                        ]
                                    )
                                )
                            ),

                            //Spacer(),
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