import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import 'book_screen.dart';


void main() {
  runApp(const MyApp());
}

class Book {
  final int id;
  final String title;
  final String genre;
  final String language;
  final String cover;
  final String summary;
  final int page_count;

  const Book({
    required this.id,
    required this.title,
    required this.genre,
    required this.language,
    required this.cover,
    required this.summary,
    required this.page_count,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: utf8.decode(json['title'].toString().runes.toList()),
      genre: utf8.decode(json['genre']["name"].toString().runes.toList()),
      language: utf8.decode(json['language']["name"].toString().runes.toList()),
      cover: "http://10.0.2.2:8000" + json['cover'],
      summary:utf8.decode(json['summary'].toString().runes.toList()),
      page_count: json['page_count'],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
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
    // return Container(
    //     decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(15),
    //     image: DecorationImage(
    //     image: NetworkImage(cover),
    //     fit:BoxFit.cover
    //     ),),
    //   child: Card(
    //     color: Colors.transparent,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    //     shadowColor: Colors.grey,
    //     child: Padding(
    //       padding: const EdgeInsets.all(20),
    //       child: Column(
    //         children: [
    //           Text(
    //             title,
    //             style: TextStyle(
    //                 color: Colors.white
    //             ),
    //           ),
    //           Text(
    //             "Жанр:  " + genre,
    //             style: TextStyle(
    //                 color: Colors.white
    //             ),
    //           ),
    //           Text(
    //             "Язык:  " + language,
    //             style: TextStyle(
    //                 color: Colors.white
    //             ),
    //           ),
    //         ],
    //       )
    //     ),
    //   ),
    // );
    return Container(
      margin:EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookScreen(id: id, title: title, genre: genre, language: language, cover: cover, summary: summary, page_count: page_count))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
            children: <Widget>[
              ClipRRect(
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
              ListTile(
                title: Text(title),
                subtitle: Text("Жанр: " + genre),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List> futureBooks;
  List<Book> books = [];

  Future<List> fetchBooks() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/api/get_all_books'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var result = jsonDecode(response.body);
      print(response.body);
      print(result.length);
      for(int i = 0; i<result["books"].length; i++){
        var book = Book.fromJson(result["books"][i]);
        books.add(book);
      }
      print(books[0].id.toString());

      return books;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("API"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder<List>(
          future: futureBooks,
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.hasData) {
              print(snapshot.data!.length);
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BigCard(
                                    id: snapshot.data?[index].id,
                                    title: snapshot.data?[index].title,
                                    genre: snapshot.data?[index].genre,
                                    language: snapshot.data?[index].language,
                                    cover: snapshot.data?[index].cover,
                                    summary: snapshot.data?[index].summary,
                                    page_count: snapshot.data?[index].page_count,
                                ),
                              );
                            }
                        )
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
