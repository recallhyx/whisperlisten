import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './routes/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '卿听',
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        "/": (context) => MyHomePage(
              channel: IOWebSocketChannel.connect('ws://echo.websocket.org'),
            ),
        "Index": (context) =>
            Index(roomId: ModalRoute.of(context).settings.arguments),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel;
  final FocusNode blankNode = FocusNode();
  MyHomePage({Key key, @required this.channel}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      widget.channel.stream.listen((message) {
        print('message$message');
        Navigator.of(context).pushReplacementNamed("Index", arguments: message);
      }, onError: (error) {
        print('error');
        final snackBar = SnackBar(
          content: Text('网络出了点问题，请稍后再试$error'),
          behavior: SnackBarBehavior.floating,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(widget.blankNode);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      '卿听',
                      style: TextStyle(
                        fontSize: 80,
                      ),
                    ),
                    Text(
                      '--独乐乐不如众乐乐',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 120,
                width: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        // width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          gradient: LinearGradient(
                            begin: Alignment(-1, -1),
                            end: Alignment(1.0, 1),
                            colors: <Color>[
                              Color(0xB2FE6B8B),
                              Color(0xFFFF8E53),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '创建房间',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                    SearchInput(channel: widget.channel),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('dispose');
    widget.channel.sink.close();
    super.dispose();
  }
}

class SearchInput extends StatefulWidget {
  final WebSocketChannel channel;
  SearchInput({Key key, @required this.channel}) : super(key: key);

  _SearchInputState createState() => new _SearchInputState();
}

class _SearchInputState extends State<SearchInput>
    with SingleTickerProviderStateMixin {
  bool isExpand = false;
  String roomId = '';
  bool isTyping = false;
  AnimationController _controller;
  Animation<double> animation;
  TextEditingController _textController = new TextEditingController();

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
      ..addListener(() {
        setState(() {});
      });
  }

  // AnimateInput animateInput = new AnimateInput();
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedInput(
                animation: animation, textController: _textController),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: isExpand
                      ? BorderRadius.only(
                          topRight: Radius.circular(3),
                          bottomRight: Radius.circular(3))
                      : BorderRadius.all(Radius.circular(3)),
                  gradient: LinearGradient(
                    begin: Alignment(-1, -1),
                    end: Alignment(1.0, 1),
                    colors: <Color>[
                      Color(0xB22196F3),
                      Color(0xFF21CBF3),
                    ],
                  )),
              child: InkWell(
                child: Icon(Icons.search),
                onTap: _handleClick,
              ),
            )
          ],
        ));
  }

  void _handleClick() {
    if (!isExpand) {
      setState(() {
        isExpand = true;
      });
      _controller.forward();
      return;
    }
    if (_textController.text.isNotEmpty) {
      print(_textController.text);
      widget.channel.sink.add(_textController.text);
    } else {
      setState(() {
        isExpand = false;
      });
      FocusScope.of(context).unfocus();
      _controller.reverse();
    }
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedInput extends AnimatedWidget {
  AnimatedInput({Key key, Animation<double> animation, this.textController})
      : super(key: key, listenable: animation);
  static final _sizeTween = Tween<double>(begin: 0, end: 110);
  final TextEditingController textController;
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      width: _sizeTween.evaluate(animation),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3), bottomLeft: Radius.circular(3))),
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            // isDense: true,
            hintText: "房间号",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 18, height: 1),
            focusColor: Colors.blue,
            // contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            // contentPadding: EdgeInsets.symmetric(
            //   vertical: 12.5,
            // )
            // contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontSize: 18,
            color: Colors.blue[500],
          ),
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.top,
        ),
      ),
    );
  }
}
