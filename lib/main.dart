import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_news_app/favourite_page.dart';
import 'package:my_news_app/model/news_hive.dart';
import 'package:my_news_app/server.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'model/news.dart';
import 'repository/news_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDcumentDir = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDcumentDir.path);
  Hive.registerAdapter(NewsHiveAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
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
      home: MyHomePage(title: 'Sport News'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController controller = ScrollController();
  List<News> list = new List<News>();
  bool hasReachMax = false;
  int page = 1;
  String no_image = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void onScroll() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroller = controller.position.pixels;
    if (maxScroll == currentScroller) {
      setState(() {
        page = page + 1;
      });
      init();
    }
  }

  @override
  void dispose() {
    list = [];
    // TODO: implement dispose
    super.dispose();
  }

  void init() async {
    try {
      List<News> article = await NewsRepository().getNews(page);
      setState(() {
        list = [...list, ...article];
        if (list.isEmpty || list.length < 10) {
          hasReachMax = true;
        }
      });
    } catch (e) {
      final snackBar = SnackBar(content: Text('Terjadi kesalahan pada server'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      print(e.toString());
    }
  }

  @override
  void initState() {
    this.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(onScroll);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context2) => FavouritePage()));
                },
                child: Icon(Icons.star)),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          child: Builder(
            builder: (ctx) {
              if (list.isEmpty) {
                return _buildListNewsEmpty();
              } else {
                return _buildListNews();
              }
            },
          ),
        ));
  }

  Widget _buildListNewsEmpty() {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (ctx, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[400],
            highlightColor: Colors.white,
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(5),
              height: 200,
            ),
          );
        });
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildListNews() {
    return ListView.separated(
        separatorBuilder: (ctx, u) {
          return Divider();
        },
        controller: controller,
        itemCount: hasReachMax == true ? list.length : list.length + 1,
        itemBuilder: (ctx, index) {
          if (index < list.length) {
            return _buildRowNews(list[index]);
          } else {
            return _buildLoading();
          }
        });
  }

  Widget _buildImage(ImageProvider provider) {
    return Container(
      // margin: EdgeInsets.only(left: 5),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            new BoxShadow(
              color: Colors.black38,
              blurRadius: 2.0,
            )
          ],
          image: DecorationImage(fit: BoxFit.cover, image: provider)),
    );
  }

  Widget _buildRowNews(News article) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        article.title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        article.description,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CachedNetworkImage(
                  imageUrl: article.urlToImage,
                  imageBuilder: (context, provider) {
                    return _buildImage(provider);
                  },
                  errorWidget: (context, url, error) {
                    return _buildImage(NetworkImage(
                        "http://manga-bat.xyz/frontend/images/404-avatar.png"));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(article.source,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    )),
                GestureDetector(
                  onTap: () async {
                    ///selalu openBox sebelum mengakses hive
                    await Hive.openBox("favourite");
                    //add to list favourite
                    var news_favourite = Hive.box("favourite");
                    news_favourite.add(NewsHive(
                        urlToImage: article.urlToImage,
                        description: article.description,
                        source: article.source,
                        title: article.title,
                        publishedAt: article.publishedAt));
                    final snackBar =
                        SnackBar(content: Text('Added to Favourite'));
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.grey),
                        SizedBox(
                          height: 3,
                        ),
                        Text("Add to Favourite",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Montserrat',
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
