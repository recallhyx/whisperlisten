import 'package:flutter/material.dart';

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
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    onTap: () {},
                  ),
                  SearchInput(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInput extends StatefulWidget {
  _SearchInputState createState() => new _SearchInputState();
}

class _SearchInputState extends State<SearchInput>
    with SingleTickerProviderStateMixin {
  bool isExpand = false;
  bool isTyping = false;
  AnimationController _controller;
  Animation<double> animation;

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<void> startAnimation() async {
    // 调用 AnimationController 的 forward 方法启动动画
    await _controller.forward();
  }

  Future<void> reverseAnimation() async {
    // 调用 AnimationController 的 forward 方法启动动画
    await _controller.reverse();
  }

  // AnimateInput animateInput = new AnimateInput();
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedInput(animation: animation),
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
    setState(() {
      isExpand = false;
    });
    FocusScope.of(context).unfocus();
    _controller.reverse();
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedInput extends AnimatedWidget {
  AnimatedInput({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  static final _sizeTween = Tween<double>(begin: 0, end: 110);
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      width: _sizeTween.evaluate(animation),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3), bottomLeft: Radius.circular(3))),
        child: TextField(
          decoration: InputDecoration(
            hintText: "请输入房间号",
            hintStyle: TextStyle(color: Colors.grey),
            focusColor: Colors.blue,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: InputBorder.none,
            // borderRadius: BorderRadius.only(topLeft: Radius.circular(3),bottomLeft: Radius.circular(3))
          ),
          style: TextStyle(
            fontSize: 16,
            color: Color(0xB22196F3),
          ),
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}