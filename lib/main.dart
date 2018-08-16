import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new NewsApp());

class NewsApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
    State<StatefulWidget> createState() {
      return new NewsAppState();
    }
}

class NewsAppState extends State<NewsApp> {
  var _isLoading = false;
  var articles;

  _fetchData() async {
    final url = 'https://newsapi.org/v1/articles?apiKey=9d10c7a2f58c474c9600538413e84222&source=bbc-news';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        _isLoading = false;
        
        this.articles = data['articles'];
        print(data['articles']);      
      });
    }
  }

  @override
    Widget build(BuildContext context) {
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('News Headlines'),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.refresh), 
                onPressed: () {
                  print('Reloading');
                  setState(() {
                    _isLoading = true;
                  });

                  _fetchData();
                },
              )
            ]
          ),
          body: new Center(
            child: _isLoading ? new CircularProgressIndicator()
              : new ListView.builder(
                itemCount: this.articles != null ? this.articles.length : 0,
                itemBuilder: (context, i) {
                  final article = this.articles[i];

                  return new Column(
                    children: <Widget>[
                      new Image.network(article['urlToImage']),
                      new Text(article['title']),
                      new Divider()
                    ],
                  );
                },
              )
          )
        ),
      );
    }
}



