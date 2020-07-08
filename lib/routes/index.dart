import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  Index({Key key, @required this.roomId}): super(key: key);
  final String roomId;
  @override
  _IndexRouteState createState() => _IndexRouteState();
}

class _IndexRouteState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('卿听${widget.roomId}'),
      ),
      body: _buildBody(), // 构建主页面
      // drawer: MyDrawer(), //抽屉菜单
    );
  }

  Widget _buildBody() {
    return Container(child: Center(child: Text('test'),),);
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
return Drawer(
      //移除顶部padding
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // _buildHeader(), //构建抽屉菜单头部
            // Expanded(child: _buildMenus()), //构建功能菜单
          ],
        ),
      ),
    );
  }
}