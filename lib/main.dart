import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

@immutable
class HomeContentModel {
  final String title;
  final List<TopicModel> topics;

  HomeContentModel({this.title, this.topics});
}

@immutable
class TopicModel {
  final String title;
  final String description;
  final String imageUrl;

  TopicModel({this.title, this.description, this.imageUrl});
}

// ignore: top_level_function_literal_block
final homeContentProvider = Provider((_) {
  final random = math.Random();
  final topics = List.generate(
      20,
      (i) => TopicModel(
            title: '$i',
            description: '${random.nextInt(99999999)}',
            imageUrl: 'https://via.placeholder.com/300',
          ));

  return HomeContentModel(title: 'TITLE', topics: topics);
});

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: DisableEffectScrollBehavior(),
          child: CustomScrollView(
            physics: PageScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                title: Text('YT Music'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.cast),
                    splashRadius: 20,
                  ),
                  IconButton(
                    onPressed: () {},
                    splashRadius: 20,
                    icon: Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: CircleAvatar(
                      backgroundColor: Colors.white30,
                      radius: 16,
                    ),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    for (int i = 0; i < 10; i++) ...[
                      const _HomeContents(),
                      const SizedBox(height: 36),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white38),
            title: Text(
              'ホーム',
              style: TextStyle(color: Colors.white),
            ),
            activeIcon: Icon(Icons.home, color: Colors.white),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore, color: Colors.white38),
            title: Text('探索'),
            activeIcon: Icon(Icons.explore, color: Colors.white),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music, color: Colors.white38),
            title: Text('ライブラリ'),
            activeIcon: Icon(Icons.library_music, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _HomeContents extends ConsumerWidget {
  const _HomeContents({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final content = watch(homeContentProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            content.title,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 220),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 8),
              for (final topic in content.topics) ...[
                _Topic(topic: topic),
                const SizedBox(width: 16),
              ],
              const SizedBox(width: 8),
            ],
          ),
        )
      ],
    );
  }
}

class _Topic extends StatelessWidget {
  const _Topic({Key key, this.topic}) : super(key: key);

  final TopicModel topic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(
          topic.imageUrl,
          width: 150,
          height: 150,
        ),
        Text(
          topic.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          topic.description,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white54),
        ),
      ],
    );
  }
}

class DisableEffectScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
