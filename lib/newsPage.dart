import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/articlesPage.dart';
import 'dart:async';
import 'dart:convert';

import 'package:news_app/model/Model.dart';


class NewsBody extends StatefulWidget {
  @override
  _NewsBodyState createState() => _NewsBodyState();
}

final String url =
    "https://newsapi.org/v2/sources?apiKey=c8a9f799877b45ff891f3ab695ae81f2";

Future<List<Source>> fetchNewsSource() async {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List sources = json.decode(response.body)['sources'];
    print('http ok');
    return (sources.map((source) => new Source.fromJson(source)).toList());
  } else {
    throw Exception('Failed to load source list');
  }
}

class _NewsBodyState extends State<NewsBody> {
  var sourceList;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("News app")),
      body: Center(
        child: RefreshIndicator(
            key: refreshKey,
            child: FutureBuilder<List<Source>>(
                future: sourceList,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<Source> sources = snapshot.data;
                    return new ListView(
                        children: sources
                            .map(
                              (source) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArticleScreen(
                                                      source: source)));
                                    },
                                    child: Card(
                                      elevation: 1.0,
                                      color: Colors.white,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 14.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 10.0),
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset(
                                                "assets/news_icon.png"),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 18.0,
                                                            horizontal: 14.0),
                                                        child: Text(
                                                          '${source.name}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            )
                            .toList());
                  }
                  return CircularProgressIndicator();
                }),
            onRefresh: refreshListSource),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshListSource();
  }

  Future<Null> refreshListSource() async {
    refreshKey.currentState?.show(atTop: false);
    setState(() {
      sourceList = fetchNewsSource();
      print(sourceList);
    });
    return null;
  }
}
