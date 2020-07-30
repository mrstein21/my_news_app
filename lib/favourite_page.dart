import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_news_app/model/news_hive.dart';

class FavouritePage extends StatefulWidget {
  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Favourite News"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
            future: Hive.openBox("favourite"),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return _buildMessage(snapshot.error.toString());
                } else {
                  var favourite = Hive.box("favourite");
                  if (favourite.length == 0) {
                    return _buildMessage("Favourite List is Empty");
                  } else {
                    return WatchBoxBuilder(
                        box: favourite,
                        builder: (ctx, news) {
                          return ListView.separated(
                              separatorBuilder: (c, i) {
                                return Divider();
                              },
                              itemCount: news.length,
                              itemBuilder: (cx, index) {
                                NewsHive news_hive = news.getAt(index);
                                return _buildRowNews(
                                    favourite, news_hive, index);
                              });
                        });
                  }
                }
              } else {
                return _buildLoading();
              }
            }),
      ),
    );
  }

  Widget _buildImage(ImageProvider provider) {
    return Container(
      margin: EdgeInsets.only(left: 5),
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

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.star,
              color: Colors.grey,
              size: 70,
            ),
            Text(
              message,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowNews(Box<dynamic> favourite, NewsHive article, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  onTap: () {
                    favourite.deleteAt(index);
                    final snackBar =
                        SnackBar(content: Text('Deleted from Favourite'));
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text("Delete from Favourite",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
