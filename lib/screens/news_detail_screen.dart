import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/news.dart';
import 'package:final_project/screens/webview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewsDetailScreen extends StatefulWidget {
  News item;
  String category;
  String name;
  NewsDetailScreen(this.item, this.category, this.name);

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool visited = false;
  String newsId = '';
  String _enteredMessage = '';
  String _finalComment = '';
  final _controller = new TextEditingController();
  void _sendMessage() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('news-comment/').doc(newsId).update({
      'comments': FieldValue.arrayUnion(
          [_finalComment + '\$' + Timestamp.now().toString()]),
      'users': FieldValue.arrayUnion(
          [widget.name + '\$' + Timestamp.now().toString()]),
    });
    _controller.clear();
  }
  // ScrollController _scrollController = ScrollController(initialScrollOffset: ScrollController().position.maxScrollExtent);

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      brightness: Brightness.dark,
      title: Text(widget.category),
      backgroundColor: Colors.blueAccent[400],
    );
    double appBarheight = appBar.preferredSize.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double maxheight =
        MediaQuery.of(context).size.height - appBarheight - statusBarHeight;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          height: maxheight,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DetailScreen(
                      widget.item.imageUrl,
                    );
                  }));
                },
                // child: Hero(
                //   tag: 'hero_img',
                child: Image.network(
                  widget.item.imageUrl,
                  height: maxheight * 0.3,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                // ),
              ),
              SizedBox(height: maxheight * 0.03),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    widget.item.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: maxheight * 0.05,
                // width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(widget.item.url),
                      ),
                    );
                  },
                  child: Text(
                    'Read More...',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: maxheight * 0.02,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'User Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
              Divider(
                height: 2,
                color: Colors.black,
              ),
              Flexible(
                child: Container(
                  child: streamDataFetch(),
                ),
              ),
              Divider(
                // height: 2,
                color: Colors.black,
                thickness: 2,
              ),
              Container(
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(40),
                //     color: Colors.white,
                //     border: Border.all(color: Colors.black)),
                margin: const EdgeInsets.only(left: 10, right: 25, bottom: 30),
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.teal, fontSize: 18),
                        controller: _controller,
                        decoration: InputDecoration(
                            // floatingLabelBehavior: FloatingLabelBehavior.never,
                            // focusedBorder: InputBorder.none,
                            // enabledBorder: InputBorder.none,
                            // errorBorder: InputBorder.none,
                            // disabledBorder: InputBorder.none,
                            // labelText: 'Add a comment...',
                            // labelStyle: TextStyle(color: Colors.black),
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(color: Colors.black)),
                        onChanged: (value) {
                          _enteredMessage = value.toString();
                        },
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            _finalComment = _enteredMessage;
                          });
                          if (_finalComment.trim().isEmpty) {
                            return null;
                          } else {
                            if (!visited) {
                              FirebaseFirestore.instance
                                  .collection('news-comment/')
                                  .add({
                                'comments': [],
                                'item_link': widget.item.url,
                              });
                              var getId = await FirebaseFirestore.instance
                                  .collection('news-comment/')
                                  .where('item_link',
                                      isEqualTo: widget.item.url)
                                  .get();
                              // print(getId.docs.length);
                              newsId = getId.docs.single.id;
                            }
                            _sendMessage();
                          }
                        },
                        child: Text(
                          'Post',
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget streamDataFetch() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('news-comment/')
          .where('item_link', isEqualTo: widget.item.url)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> commentSnapshot) {
        if (commentSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final commentDocs = commentSnapshot.data?.docs;

          if (commentDocs!.length > 0 &&
              commentDocs[0]['comments'].length > 0) {
            visited = true;
            newsId = commentDocs[0].id;
            // print(true);
            // print(commentDocs[0]['comments'][0]);
            return ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                itemCount: commentDocs[0]['comments'].length,
                itemBuilder: (context, index) {
                  int ind = commentDocs[0]['comments'].length - index - 1;
                  var commentOriginal = commentDocs[0]['comments'][ind];
                  var userOriginal = commentDocs[0]['users'][ind];
                  print(userOriginal);
                  int i = commentOriginal.indexOf('\$');
                  var comment = commentOriginal.substring(0, i);
                  i = userOriginal.indexOf('\$');
                  var user = userOriginal.substring(0, i);
                  if (user == widget.name) {
                    user = user + " (Me)";
                  }

                  return Column(
                    children: [
                      ListTile(
                        leading: Text(
                          user,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        title: Text(
                          comment,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        trailing: user == widget.name + " (Me)"
                            ? IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('news-comment/')
                                      .doc(newsId)
                                      .update({
                                    'comments': FieldValue.arrayRemove(
                                        [commentOriginal]),
                                    'users':
                                        FieldValue.arrayRemove([userOriginal]),
                                  });
                                },
                              )
                            : Text(''),
                      ),

                      // Divider(
                      //   height: 2,
                      //   color: Colors.black,
                      // )
                    ],
                  );
                });
          } else {
            // newsId = commentDocs[0].id;
            return Center(
              child: Container(
                child: Text('No comments Yet'),
              ),
            );
          }
        }
      },
    );
  }
}

class DetailScreen extends StatelessWidget {
  String url;
  DetailScreen(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700] ?? Colors.grey.withOpacity(0.3),
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          // child: Hero(
          //   tag: 'hero_img',
          child: Image.network(
            url,
          ),
          // ),
        ),
      ),
    );
  }
}
