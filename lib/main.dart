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

      this._dumpListenInfo();
    });
  }

  void _dumpListenInfo() {
    print("(double) is ${this._partialPage}");
    print("(ceil) is ${this._partialPage.ceil()}");
    print("(floor) is ${this._partialPage.floor()}");
  }

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
          dumpPageInfo(index);

          final offset = this._partialPage - this._partialPage.toInt();

          return Transform(
            transform: Matrix4.identity()
              ..rotateY(offset)
              ..rotateZ(offset),
            alignment: FractionalOffset.center,
            child: CarouselPage(
              onMove: (target) {
                this._cntrl.jumpToPage(target);
              },
              text: index.toString(),
              color: Color.fromARGB(255, Random().nextInt(256),
                  Random().nextInt(256), Random().nextInt(256)),
            ),
          );
        },
        itemCount: NUM_ITEMS);
  }

  bool _isValidIndex(int index) => ((0 <= index) && (index <= NUM_ITEMS - 1));

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
