import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'search_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainPageState();
}

class _Page {
  _Page({this.label, this.colors, this.icon});

  final String label;
  final MaterialColor colors;
  final IconData icon;

  Color get labelColor =>
      colors != null ? colors.shade300 : Colors.grey.shade300;

  bool get fabDefined => colors != null && icon != null;

  Color get fabColor => colors.shade400;

  Icon get fabIcon => Icon(icon);

  Key get fabKey => ValueKey<Color>(fabColor);
}

final List<_Page> _allPages = <_Page>[
  _Page(label: 'Blue', colors: Colors.indigo, icon: Icons.add),
  _Page(label: 'Eco', colors: Colors.green, icon: Icons.create),
];

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final SearchPageSearchDelegate _delegate = SearchPageSearchDelegate();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _lastIntegerSelected;

  TabController _controller;
  _Page _selectedPage;
  bool _extendedButtons = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);
    _controller.addListener(_handleTabSelection);
    _selectedPage = _allPages[0];
  }

  void _handleTabSelection() {
    setState(() {
      _selectedPage = _allPages[_controller.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Navigation menu',
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            color: Colors.white,
            progress: _delegate.transitionAnimation,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: const Text("音乐湖"),
        bottom: TabBar(
          controller: _controller,
          tabs: _allPages
              .map<Widget>((_Page page) => Tab(text: page.label.toUpperCase()))
              .toList(),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () async {
              final int selected = await showSearch<int>(
                context: context,
                delegate: _delegate,
              );
              if (selected != null && selected != _lastIntegerSelected) {
                setState(() {
                  _lastIntegerSelected = selected;
                });
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: _allPages.map<Widget>(buildTabView).toList(),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Peter Widget'),
              accountEmail: Text('peter.widget@example.com'),
              currentAccountPicture: CircleAvatar(),
              margin: EdgeInsets.zero,
            ),
            MediaQuery.removePadding(
              context: context,
              // DrawerHeader consumes top MediaQuery padding.
              removeTop: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.playlist_play),
                    title: const Text('播放队列'),
                    onTap: _showNotImplementedMessage,
                  ),
                  ListTile(
                    leading: Icon(Icons.equalizer),
                    title: Text('均衡器'),
                    onTap: _showNotImplementedMessage,
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('关于'),
                    onTap: _showNotImplementedMessage,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('设置'),
                    onTap: _showNotImplementedMessage,
                  ),
                  ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text('反馈'),
                    onTap: _showNotImplementedMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _DemoBottomAppBar(
        color: Colors.amber,
//        fabLocation: _fabLocation.value,
//        shape: _selectNotch(),
      ),
    );
  }

  Widget buildTabView(_Page page) {
    return Builder(builder: (BuildContext context) {
      return Container(
          key: ValueKey<String>(page.label),
          child: Column(
            children: <Widget>[
              Card(
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.library_music,
                        color: Colors.green,
                      ),
                      title: const Text('本地音乐'),
                      onTap: _showNotImplementedMessage,
                    ),
                    ListTile(
                      leading: Icon(Icons.history, color: Colors.black),
                      title: Text('播放历史'),
                      onTap: _showNotImplementedMessage,
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.favorite_border, color: Colors.redAccent),
                      title: Text('我的收藏'),
                      onTap: _showNotImplementedMessage,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.video_library,
                        color: Colors.orange,
                      ),
                      title: Text('本地视频'),
                      onTap: _showNotImplementedMessage,
                    ),
                  ],
                )),
              ),
              Card(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text("我的歌单"),
                              margin: EdgeInsets.all(16.0),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                ),
                                onPressed: () {})
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                ),
              ),
            ],
          ));
    });
  }

  void _showNotImplementedMessage() {}
}

class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar({
    this.color,
    this.fabLocation,
    this.shape,
  });

  final Color color;
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape shape;

  static final List<FloatingActionButtonLocation> kCenterLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContents = <Widget>[
      Text("歌曲名\n歌手名"),
    ];

    if (kCenterLocations.contains(fabLocation)) {
      rowContents.add(
        const Expanded(child: SizedBox()),
      );
    }

    rowContents.addAll(<Widget>[
      IconButton(
        icon: Icon(
          Theme.of(context).platform == TargetPlatform.iOS
              ? Icons.more_horiz
              : Icons.more_vert,
          semanticLabel: 'Show menu actions',
        ),
        onPressed: () {
          Scaffold.of(context).showSnackBar(
            const SnackBar(content: Text('This is a dummy menu action.')),
          );
        },
      ),
    ]);

    return BottomAppBar(
      color: color,
      child: Container(
        margin: EdgeInsets.only(left: 16),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowContents),
      ),
      shape: shape,
    );
  }
}
