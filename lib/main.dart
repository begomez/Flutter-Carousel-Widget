import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      title: 'Carousel Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Carousel Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: TransformerCarouselWidget(),
    ));
  }
}

class TransformerCarouselWidget extends StatefulWidget {
  TransformerCarouselWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TransformerCarouselWidgetState();
  }
}

class _TransformerCarouselWidgetState extends State<TransformerCarouselWidget> {
  PageController _cntrl;
  double _partialPage = 0.0;
  int _page = 0;
  bool _forward = true;
  double PI = 3.141592;

  @override
  void initState() {
    super.initState();

    this._initController();
  }

  void _initController() {
    this._cntrl = PageController();

    this._cntrl.addListener(() {
      this.setState(() {
        this._partialPage = this._cntrl.page;
      });

      //this._dumpListenInfo();
    });
  }

  void _dumpListenInfo() {
    print("(double) is ${this._partialPage}");
    print("(ceil) is ${this._partialPage.ceil()}");
    print("(floor) is ${this._partialPage.floor()}");
  }

  double FRACTION = 0.3;

  @override
  Widget build(BuildContext cntxt) {
    return PageView.builder(
        pageSnapping: true,
        controller: this._cntrl,
        onPageChanged: (int index) {
          this.setState(() {
            this._forward = this._page < index;

            this._page = index;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          //dumpPageInfo(index);
          //dumpForwardBackward(index);

          final offset = this._partialPage - this._partialPage.toInt();

          int from = this.getFrom(index);
          int to = this.getTo(index);

          print("index: $index from: $from to: $to forward: $_forward");

          if (_forward) {
            if (index == from) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateY(offset)
                  ..rotateZ(offset),
                alignment: FractionalOffset.topCenter,
                child: CarouselPage(
                  onMove: (target) {
                    this._cntrl.jumpToPage(target);
                  },
                  text: index.toString(),
                  color: Color.fromARGB(255, Random().nextInt(256),
                      Random().nextInt(256), Random().nextInt(256)),
                ),
              );
            } else if (index == to) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateY(0.0)
                  ..rotateZ(0.0),
                alignment: FractionalOffset.topCenter,
                child: CarouselPage(
                  onMove: (target) {
                    this._cntrl.jumpToPage(target);
                  },
                  text: index.toString(),
                  color: Color.fromARGB(255, Random().nextInt(256),
                      Random().nextInt(256), Random().nextInt(256)),
                ),
              );
            } else {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateY(offset)
                  ..rotateZ(offset),
                alignment: FractionalOffset.topCenter,
                child: CarouselPage(
                  onMove: (target) {
                    this._cntrl.jumpToPage(target);
                  },
                  text: index.toString(),
                  color: Color.fromARGB(255, Random().nextInt(256),
                      Random().nextInt(256), Random().nextInt(256)),
                ),
              );
            }
          } else {
            if (index == from) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateY(0.0)
                  ..rotateZ(0.0),
                alignment: FractionalOffset.topCenter,
                child: CarouselPage(
                  onMove: (target) {
                    this._cntrl.jumpToPage(target);
                  },
                  text: index.toString(),
                  color: Color.fromARGB(255, Random().nextInt(256),
                      Random().nextInt(256), Random().nextInt(256)),
                ),
              );
            } else if (index == to) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateY(offset)
                  ..rotateZ(offset),
                alignment: FractionalOffset.topCenter,
                child: CarouselPage(
                  onMove: (target) {
                    this._cntrl.jumpToPage(target);
                  },
                  text: index.toString(),
                  color: Color.fromARGB(255, Random().nextInt(256),
                      Random().nextInt(256), Random().nextInt(256)),
                ),
              );
            } else {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateY(-offset)
                  ..rotateZ(-offset),
                alignment: FractionalOffset.topCenter,
                child: CarouselPage(
                  onMove: (target) {
                    this._cntrl.jumpToPage(target);
                  },
                  text: index.toString(),
                  color: Color.fromARGB(255, Random().nextInt(256),
                      Random().nextInt(256), Random().nextInt(256)),
                ),
              );
            }
          }
        },
        itemCount: NUM_ITEMS);
  }

  bool focus(int number) => true;

  bool swipedTo(int number) => true;

  bool swipedFrom(int number) => true;

  bool _isValidIndex(int index) => ((0 <= index) && (index <= NUM_ITEMS - 1));

  void dumpForwardBackward(int target) {
    print("page: $target partial: $_partialPage");
    if (this._forward) {
      print("from: ${this._partialPage.floor().toInt()}");
      print("to: ${(this._partialPage + 1).floor()}");
    } else {
      print("from: ${this._partialPage.ceil()}");
      print("to: ${this._partialPage.floor()}");
    }
  }

  int getTo(int target) {
    int to = target;
    if (this._forward) {
      to = (this._partialPage + 1).floor();
    } else {
      to = this._partialPage.floor();
    }

    return to;
  }

  int getFrom(int target) {
    int from = target;

    if (this._forward) {
      from = this._partialPage.floor().toInt();
    } else {
      from = this._partialPage.ceil();
    }

    return from;
  }

  void dumpPageInfo(int index) {
    print("GONNA BUILD page for ${index}");
    print("partial page is ${this._partialPage}");
    print("_prev is ${this._getPrev(index)}");
    print("_post is ${this._getPost(index)}");
    print("going forward? ${this._forward}");
    print("---------------------------------");
  }

  int _getPrev(int index) => index - 1;

  int _getPost(int index) => index + 1;

  void jumpToPage() {
    this._cntrl.jumpTo(0);
  }
}

class CarouselPage extends StatelessWidget {
  final Color color;
  final String text;
  final Function(int) onMove;

  CarouselPage({this.color, this.text, this.onMove, Key key}) : super(key: key);

  @override
  Widget build(BuildContext cntxt) {
    return Container(
        height: MediaQuery.of(cntxt).size.height,
        color: this.color,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(text.toString()),
                      FlatButton(
                        child: Text("Jump"),
                        onPressed: () {
                          this.onMove(5);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                ),
              ),
            ]));
  }
}

final int NUM_ITEMS = 10;
