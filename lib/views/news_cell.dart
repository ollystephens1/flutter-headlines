import 'package:flutter/material.dart';

class NewsCell extends StatelessWidget {
  final article;

  NewsCell(this.article);

  @override
    Widget build(BuildContext context) {
      return new Column(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.all(10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Image.network(article['urlToImage']),
                new Container(height: 8.0),
                new Text(article['title'], 
                  style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                new Text(article['description'])
              ]
            )
          ),
          
          new Divider()
        ],
      );
    }
}