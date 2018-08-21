import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './views/news_cell.dart';
import './models/choice.model.dart';

void main() => runApp(new NewsApp());

class NewsApp extends StatefulWidget {
  // App root widget
  @override
    State<StatefulWidget> createState() {
      return new NewsAppState();
    }
}

class NewsAppState extends State<NewsApp> {
  bool _isLoading = false;
  dynamic articles;
  String _title = 'News headlines';

  _fetchData([String source]) async {
    String newsSource = 'bbc-news';

    if (source != null) {
      newsSource = source;
    }

    final int selectedSource = choices.indexWhere((choice) => choice.slug == newsSource);
    final String url = 'https://newsapi.org/v1/articles?apiKey=9d10c7a2f58c474c9600538413e84222&source=' + newsSource;
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      setState(() {
        _isLoading = false;
        _title = choices[selectedSource].title;
        this.articles = data['articles'];
      });
    }
  }

  void _select(Choice choice) {
    _fetchData(choice.slug);
  }

  @override
    Widget build(BuildContext context) {
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text(_title),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });

                  _fetchData();
                },
              ),
              PopupMenuButton(
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.map((Choice choice) {
                    return PopupMenuItem<Choice>(
                      value: choice,
                      child: Text(choice.title),
                    );
                  }).toList();
                },
              )
            ],
          ),
          body: new Center(
            child: _isLoading ? new CircularProgressIndicator()
              : new ListView.builder(
                itemCount: this.articles != null ? this.articles.length : 0,
                itemBuilder: (context, i) {
                  final article = this.articles[i];
                  return new NewsCell(article);
                },
              )
          )
        ),
      );
    }
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'BBC News', slug: 'bbc-news'),
  const Choice(title: 'Associated Press', slug: 'associated-press'),
  const Choice(title: 'CNN', slug: 'cnn'),
  const Choice(title: 'Daily Mail', slug: 'daily-mail'),
  const Choice(title: 'ESPN', slug: 'espn'),
  const Choice(title: 'Reuters', slug: 'reuters')
];
