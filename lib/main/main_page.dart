import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'search_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final SearchPageSearchDelegate _delegate = SearchPageSearchDelegate();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _lastIntegerSelected;

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
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Peter Widget'),
              accountEmail: Text('peter.widget@example.com'),
              currentAccountPicture: CircleAvatar(
              ),
              margin: EdgeInsets.zero,
            ),
            MediaQuery.removePadding(
              context: context,
              // DrawerHeader consumes top MediaQuery padding.
              removeTop: true,
              child: const ListTile(
                leading: Icon(Icons.payment),
                title: Text('Placeholder'),
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

  @override
  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  ///生成一行
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  ///跳转到收藏
  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided =
          ListTile.divideTiles(tiles: tiles, context: context).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Saved Suggestions"),
        ),
        body: new ListView(children: divided),
      );
    }));
  }
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

  static final List<FloatingActionButtonLocation> kCenterLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContents = <Widget> [
      Text("歌曲名\n歌手名"),
    ];

    if (kCenterLocations.contains(fabLocation)) {
      rowContents.add(
        const Expanded(child: SizedBox()),
      );
    }

    rowContents.addAll(<Widget> [
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
            children: rowContents
        ),
      ),
      shape: shape,
    );
  }
}
