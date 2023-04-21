import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BookScreen extends StatelessWidget{
  const BookScreen({
    super.key,
    required this.id,
    required this.title,
    required this.genre,
    required this.language,
    required this.cover,
    required this.summary,
    required this.page_count,
  });

  final int id;
  final String title;
  final String genre;
  final String language;
  final String cover;
  final String summary;
  final int page_count;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.network(
                    cover,
                    // width: 300,
                    height: 150,
                    fit:BoxFit.fill

                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  Text("Книга: " + title),
                  Text("Жанр: " + genre),
                  Text("Язык: " + language),
                  Text("Количество страниц: " + page_count.toString()),
                  Text(summary),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}