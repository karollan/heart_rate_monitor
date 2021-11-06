

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate_monitor/home_screen.dart';
import 'package:heart_rate_monitor/models/measure.dart';


//About Page
class HistoryPage extends StatefulWidget {

  @override
  _HistoryPageState createState() => _HistoryPageState();

}

class _HistoryPageState extends State<HistoryPage> {
  List<Widget> _measureTiles = [];
  final GlobalKey _listKey = GlobalKey();
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Measure> measureList = List.empty(growable: true);

  void showMeasureDialog(BuildContext context, Measure measure) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/${measure.img}',
                            height: 100.0,),
                          SizedBox(width: 30),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(measure.result, style: TextStyle(fontFamily: 'Montserrat Medium', fontSize:32)),
                              Text(measure.date, style: TextStyle(fontFamily: 'Montserrat Medium', fontSize:16)),
                            ]
                          )
                        ]
                    )
                ),
                Text('GRAPH'),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(minHeight: 50.0),
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                              deleteData(measure.id!);
                              Navigator.pop(context);
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
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Delete',
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
                      SizedBox(width: 40),
                      Container(
                        constraints: BoxConstraints(minHeight: 50.0),
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            onPrimary: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Cancel',
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
                  ),
                )

              ]
            )
          )
        );
      }
    );
  }

  Widget _buildTile(Measure measure) {
    return Card(
      child: ListTile(
        onTap: () {
          showMeasureDialog(context, measure);
        },
        contentPadding: EdgeInsets.all(25),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(measure.result, style: TextStyle(fontFamily: 'Montserrat Medium')),
            Text(measure.date, style: TextStyle(fontSize: 12, fontFamily: 'Montserrat Regular'))
          ],
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/${measure.img}',
            height: 50.0,
          ),
        ),
        trailing: Text(measure.graph),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshDataList();
  }

  refreshDataList() {
    setState(() {
      getAllData();
    });
  }

  void getAllData() async {
    final measures = await databaseHelper.queryAllMeasures();
    setState(() {
      measureList = measures;
      _measureTiles = [];
      measureList.forEach((Measure measure) {
        _measureTiles.add(_buildTile(measure));
      });
    });
  }

  void deleteData(int itemId) async {
    await databaseHelper.deleteMeasure(itemId);
    refreshDataList();
  }

  @override
  Widget build(BuildContext context) {
    //get size
    var size = MediaQuery.of(context).size;

    //scroll controller
    final _scrollController = ScrollController();

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
                children: <Widget> [
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


                  Expanded(
                        child: ListView.builder(
                            key: _listKey,
                            itemCount: measureList.length,
                            itemBuilder: (context, index) {
                              return _measureTiles[index];
                            }
                        ),
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
