import 'package:flutter/material.dart';
import 'package:news_app/model/Model.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetails extends StatefulWidget {
  final Article article;

  const ArticleDetails({Key key, this.article}) : super(key: key);

  @override
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
              child: widget.article.urlToImage != null
                  ? Image.network(widget.article.urlToImage)
                  : Icon(Icons.description),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: widget.article.title != null
                  ? Text(
                      widget.article.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(""),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: widget.article.description != null
                  ? Text(
                      widget.article.description,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  : Text(""),
            ),
            GestureDetector(
              onTap: () {
                _launchUrl(widget.article.url);
              },
              child: Text(
                "Read more ..",
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw {'error while launching url'};
    }
  }
}
