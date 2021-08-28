import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/fetching_data_from_api/get_news_data.dart';
import 'package:final_project/models/news.dart';
import 'package:final_project/screens/news_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewsLists extends StatefulWidget {
  String country;
  String category;
  BoxConstraints constraints;
  String displayedCategory;
  String displayedCountry;
  NewsLists(this.country, this.category, this.constraints,
      this.displayedCategory, this.displayedCountry);

  @override
  _NewsListsState createState() => _NewsListsState();
}

class _NewsListsState extends State<NewsLists> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // height: constraints.maxHeight * 0.64,

        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: widget.constraints.maxHeight * 0.06,
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Text(
                "${widget.displayedCategory} news in ${widget.displayedCountry}:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 300),
              child: Divider(
                height: widget.constraints.maxHeight * 0.02,
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 20),
              child: SizedBox(
                height: widget.constraints.maxHeight * 0.01,
              ),
            ),
            FutureBuilder<List<dynamic>>(
                future: getNewsData(widget.country, widget.category),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      height: widget.constraints.maxHeight * 0.5,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.brown,
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, i) {
                              News item = News(
                                  snapshot.data?[i].title,
                                  snapshot.data?[i].url,
                                  snapshot.data?[i].imageUrl,
                                  snapshot.data?[i].content);
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      var exec = await FirebaseFirestore
                                          .instance
                                          .collection('users/')
                                          .where('email',
                                              isEqualTo: FirebaseAuth
                                                  .instance.currentUser?.email)
                                          .get();
                                      var getName =
                                          exec.docs[0].data()['username'];
                                      // var a = getName.docs[0].data();
                                      // print(getId.docs.length);
                                      // getName.newsId = getId.docs.single.id;
                                      Navigator.of(context)
                                          .push(PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            NewsDetailScreen(
                                                item,
                                                widget.displayedCategory,
                                                getName),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(0.0, 1.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                        transitionDuration:
                                            Duration(milliseconds: 1000),
                                      ));

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         NewsDetailScreen(item, getName,
                                      //             widget.displayedCategory),
                                      //   ),
                                      // );
                                    },
                                    trailing: Image.network(
                                      snapshot.data?[i].imageUrl,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.fill,
                                    ),
                                    title: Text(snapshot.data?[i].title),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    height: widget.constraints.maxHeight * 0.03,
                                  )
                                ],
                              );
                            }),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
