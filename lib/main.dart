import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DemoApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  int c =0;
  static String key = "AIzaSyCRM4kALMGi9ogN7BkMYytzI8W98s-6_Bo";
  String query = "App Development";
  YoutubeAPI ytApi = YoutubeAPI(key);
  List<YT_API> ytResult = [];

  callAPI(query) async {
    ytResult = await ytApi.search(query);
    ytResult = await ytApi.nextPage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callAPI(query);
    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.grey[400],
        child: ListView.builder(
          itemCount: ytResult.length,
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index - 1);
          },
        ),
      ),
    );
  }

  _searchBar() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
        padding: EdgeInsets.symmetric(vertical: 3),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                hintText: "Search ..."),
            onChanged: (text) {
              c++;
              text = text.toLowerCase();
              setState(() {
                if(c==4) {
                  c=0;
                  callAPI(text);
                }
                if(text.isEmpty){
                  print('Enter Keyword');
                  callAPI(query);
                }
              });
            },
          ),
        ));
  }

  _listItem(index) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            Image.network(
              ytResult[index].thumbnail['default']['url'],
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(
                    ytResult[index].title,
                    softWrap: true,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 1.5)),
                  Text(
                    ytResult[index].channelTitle,
                    softWrap: true,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 3.0)),
                  Text(
                    ytResult[index].url,
                    softWrap: true,
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
