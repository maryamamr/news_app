import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/articleDetails.dart';
import 'dart:async';
import 'dart:convert';

import 'package:news_app/model/Model.dart';

final String apiKey = "c8a9f799877b45ff891f3ab695ae81f2";

Future<List<Article>> fetchArticleBySource(String source) async {
  print(source);
  final response = await http.get(
      "https://newsapi.org/v2/top-headlines?sources=$source&apiKey=$apiKey");
  if (response.statusCode == 200) {
    List articles = json.decode(response.body)['articles'];
    print('http ok');
    return (articles.map((article) => new Article.fromJson(article)).toList());
  }
  else {
    throw Exception('Failed to load article');
  }
}

class ArticleScreen extends StatefulWidget {
  final Source source;

  const ArticleScreen({Key key, this.source}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  var articlesList;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.source.name)),
      body: Center(
        child: RefreshIndicator(
            key: refreshKey,
            child: FutureBuilder<List<Article>>(
                future: articlesList,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<Article> articles = snapshot.data;
                    return new ListView(
                        children: articles
                            .map(
                              (article) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                      ArticleDetails(article: article,)
                                      ));
                                    },
                                    child: Card(
                                      elevation: 1.0,
                                      color: Colors.white,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 4.0),
                                            child: article.urlToImage != null
                                                ? Image.network(
                                                    article.urlToImage)
                                                : Icon(Icons.description),
                                          ),
                                          Container(
                                            alignment: Alignment.topRight,
                                            margin: const EdgeInsets.all(2.0),
                                            child: article.source != null
                                                ? Text(
                                              "${article.publishedAt}",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0,
                                              ),
                                            )
                                                : Text(""),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10.0),
                                            child: article.title != null
                                                ? Text(
                                                    article.title,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : Text(""),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                            )
                            .toList());
                  }
                  return CircularProgressIndicator();
                }),
            onRefresh: refreshArticle),
      ),
    );
  }

  Future<Null> refreshArticle() async {
    refreshKey.currentState?.show(atTop: false);
    setState(() {
      articlesList = fetchArticleBySource(widget.source.id);
    });
    return null;
  }
}

