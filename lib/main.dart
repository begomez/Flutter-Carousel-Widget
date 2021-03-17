import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      child: CarouselPageView(),
    ));
  }
}

class CarouselPageView extends StatefulWidget {
  CarouselPageView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CarouselPageViewState();
  }
}

class _CarouselPageViewState extends State<CarouselPageView> {
  PageController _cntrl;
  double _partialPage = 0.0;
  int _page = 0;
  bool _goingForward = true;
  static const double PI = 3.141592;

  _CarouselPageViewState() : super();

  @override
  void initState() {
    super.initState();

    this._initPageController();
  }

  void _initPageController() {
    this._cntrl = PageController();

    this._cntrl.addListener(() {
      this.setState(() {
        this._partialPage = this._cntrl.page;
      });

      //this._dumpListenInfo();
    });
  }

  void _dumpListenInfo() {
    print("Partial page is ${this._partialPage}");
    print("Upper partial page is ${this._partialPage.ceil()}");
    print("Lower partial page is ${this._partialPage.floor()}");
  }

  @override
  void dispose() {
    this._disposePageController();

    super.dispose();
  }

  void _disposePageController() {
    this._cntrl.dispose();
  }

  @override
  Widget build(BuildContext cntxt) {
    return PageView.builder(
        pageSnapping: true,
        controller: this._cntrl,
        onPageChanged: (int newPage) {
          this._storeCurrentPage(newPage);
        },
        itemBuilder: (BuildContext context, int index) {
          final offset = (this._partialPage - this._partialPage.toInt());

          int from = this._getIndexForPageSwipingFrom(index);
          int to = this._getIndexForPageSwipedTo(index);

          print("index: $index from: $from to: $to forward: $_goingForward");

          // LEFT 2 RIGHT
          if (_goingForward) {
            if (index == to) {
              return _wrapPage(Colors.red, index.toString(), (int page) {
                this._jumpToPage(page);
              }, 0.0);
            } else {
              return _wrapPage(Colors.yellow, index.toString(), (int page) {
                this._jumpToPage(page);
              }, offset);
            }

            // RIGHT 2 LEFT
          } else {
            if (index == from) {
              return _wrapPage(Colors.green, index.toString(), (int page) {
                this._jumpToPage(page);
              }, 0.0);
            } else {
              return _wrapPage(Colors.blue, index.toString(), (int page) {
                this._jumpToPage(page);
              }, offset);
            }
          }
        },
        itemCount: NUM_ITEMS);
  }

  void _storeCurrentPage(int newPage) {
    this.setState(() {
      this._goingForward = (this._page < newPage);

      this._page = newPage;
    });
  }

  bool _isValidIndex(int index) => ((0 <= index) && (index <= NUM_ITEMS - 1));

  void dumpForwardBackward(int target) {
    print("page: $target partial page: $_partialPage");
    print("from: ${this._getIndexForPageSwipingFrom(target)}");
    print("to: ${this._getIndexForPageSwipedTo(target)}");
  }

  int _getIndexForPageSwipedTo(int target) {
    int toIndex = target;

    if (this._goingForward) {
      toIndex = (this._partialPage + 1).floor();
    } else {
      toIndex = this._partialPage.floor();
    }

    return toIndex;
  }

  int _getIndexForPageSwipingFrom(int target) {
    int fromIndex = target;

    if (this._goingForward) {
      fromIndex = this._partialPage.floor().toInt();
    } else {
      fromIndex = this._partialPage.ceil();
    }

    return fromIndex;
  }

  void _jumpToPage(int target) {
    this._cntrl.jumpToPage(target);
  }

  Widget _wrapPage(Color color, String text, Function onMove, double angle) {
    return Transform(
      alignment: FractionalOffset.topCenter,
      transform: Matrix4.identity()
        ..rotateY(angle)
        ..rotateZ(angle),
      child: CarouselPage(
        color: color,
        text: text,
        onMove: onMove,
      ),
    );
  }
}

/**
 * 
 */
class CarouselPage extends StatelessWidget {
  final Color color;
  final String text;
  final Function(int) onMove;

  CarouselPage({this.color, this.text, this.onMove, Key key}) : super(key: key);

  @override
  Widget build(BuildContext cntxt) {
    return Container(
        height: MediaQuery.of(cntxt).size.height,
        color: color,
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
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          color: Colors.orange,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Jump"),
                          ),
                          onPressed: () {
                            this.onMove(Random().nextInt(NUM_ITEMS));
                          },
                        ),
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
