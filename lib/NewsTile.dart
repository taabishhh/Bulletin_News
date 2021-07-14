import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Register.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'SavedNews.dart';
import 'ArticleView.dart';

class NewsTile extends StatefulWidget {
  final String imgUrl, title, desc, content, posturl, author; //publishedAt;
  // final bool saved;
  NewsTile(
      { //this.saved,
      this.imgUrl,
      this.desc,
      this.title,
      this.content,
      this.author,
      // this.publishedAt,
      @required this.posturl});
  @override
  NewsList createState() => NewsList(
        // saved: saved,
        imgUrl: imgUrl,
        title: title,
        author: author,
        desc: desc,
        content: content,
        // publishedAt: publishedAt,
        posturl: posturl,
      );
}

class NewsList extends State<NewsTile> {
  // void init() {
  //   super.initState();
  //   checksaved(title, context);
  // }
  // bool saved;
  final String imgUrl, title, desc, content, posturl, author; //publishedAt;
  bool saved = false;
  // bool _loading = false;
  NewsList(
      { //this.saved,
      this.imgUrl,
      this.desc,
      this.title,
      this.content,
      this.author,
      // this.publishedAt,
      @required this.posturl});

  final User user = FirebaseAuth.instance.currentUser;
  //final uid = user.uid;
  final databaseReference = FirebaseFirestore.instance;
  Future<void> saveNews(BuildContext context) async {
    try {
      await databaseReference
          .collection("users")
          .doc(user.uid)
          .collection('saved_news')
          .doc(title)
          .set({
        'imgUrl': imgUrl.toString(),
        'title': title.toString(),
        'description': desc.toString(),
        'content': content.toString(),
        'posturl': posturl.toString()
      });
      displayToastMessage('Saved', context);
      if (mounted) {
        setState(() {
          // _loading = false;
          saved = true;
          // Home n=new Home();n.checksaved(title, context);
        });
      }
      // saved = true;
      // checksaved(title,context);
    } catch (e) {
      displayToastMessage(e, context);
    }

    // DocumentReference ref = await databaseReference.collection("books").add({
    //   'title': 'Flutter in Action',
    //   'description': 'Complete Programming Guide to learn Flutter'
    // });
    // print(ref.id);
  }

  Future<void> deleteNews(BuildContext context) async {
    try {
      await databaseReference
          .collection("users")
          .doc(user.uid)
          .collection('saved_news')
          .doc(title)
          .delete();
      displayToastMessage('Unsaved', context);
      if (mounted) {
        setState(() {
          // _loading = false;
          saved = false;
          newslists.removeWhere((item) => item.title == this.title);
          // print(newslists);
          if (saveview) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SavedNews()));
            // Saved sn=new Saved();
            // sn.getSavedNews();
          }
          // Home n=new Home();n.checksaved(title, context);
        });
      }
      // ignore: unrelated_type_equality_checks

      // saved = true;
      // checksaved(title,context);
    } catch (e) {
      displayToastMessage(e, context);
    }

    // DocumentReference ref = await databaseReference.collection("books").add({
    //   'title': 'Flutter in Action',
    //   'description': 'Complete Programming Guide to learn Flutter'
    // });
    // print(ref.id);
  }

  void checksaved(index, BuildContext context) async {
    //add index argument

    try {
      // ignore: await_only_futures
      var snap = await databaseReference
          .collection("users")
          .doc(user.uid)
          .collection('saved_news')
          .where('title', isEqualTo: title)
          .get();
      //((result) => {
      // print(value.data.contains(title));
      // for(var doc in snap.docs) {
      if (snap.docs != null && snap.docs.isNotEmpty) {
        if (mounted) {
          setState(() => {saved = true});
        }
        // print(title);
      } else {
        if (mounted) {
          setState(() => {saved = false});
        }
        // print(title+'false');
      }

      //newslist[index].title)) {
      // print(doc.id.contains(newslist[index].title));
      // setState(() {
      // _loading = false;
      // saved = true;
      // break;
      // });
      // print(newslist[index].title);print(saved);
      // else {
      // print(newslist[index].title + '  false');
      // setState(() {
      // _loading = false;
      // saved = false;
      // });

      // }
      // print(doc.id);
      // }
      // });
      // if (value.data()['title'] == title) {
      //   sav = true;
      // } else {
      //   sav = false;
      // }
      // sav=true;
      // }
    } catch (e) {
      displayToastMessage(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    checksaved(title, context);
    // saved = false;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: Container(
        child: Column(children: <Widget>[
          GestureDetector(
            onTap: () {
              print(posturl);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArticleView(
                            postUrl: posturl,
                          )));
            },
            child: Container(
              height: 250,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              // alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  // border: Border.all(
                  // width: 3, color: Colors.black87, style: BorderStyle.solid),
                  image: DecorationImage(
                    image: NetworkImage(imgUrl),
                    fit: BoxFit.cover,
                    colorFilter:
                        new ColorFilter.mode(Colors.black45, BlendMode.darken),
                  ),
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child:
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   // crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                  Column(mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    // ClipRRect(
                    //     borderRadius: BorderRadius.circular(6),
                    //     child: Image.network(
                    //       imgUrl,
                    //       color: Colors.black26,
                    //       colorBlendMode: BlendMode.darken,
                    //       //filterQuality: FilterQuality.medium,// ColorFilter.mode(Colors.black54, BlendMode.darken),
                    //       height: 150,
                    //       width: MediaQuery.of(context).size.width,
                    //       fit: BoxFit.cover,
                    //     )),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25))),
                            child: Text(
                              title,
                              maxLines: 2,
                              style:
                                  // TextStyle(
                                  //   foreground: Paint()
                                  //     ..style = PaintingStyle.stroke
                                  //     ..strokeWidth = 1
                                  //     ..color = Colors.black,
                                  // ),
                                  GoogleFonts.workSans(
                                textStyle: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 5.0,
                                        color: Colors.black),
                                    Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 5.0,
                                        color: Colors.black),
                                  ],
                                ),
                                fontWeight: FontWeight.w500,
                                fontSize: 19,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            // height:50,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              // gradient: LinearGradient(
                              // begin: Alignment.topCenter,
                              // end: Alignment.bottomCenter,
                              // colors: [Colors.transparent, Colors.grey[900]],
                              // begin: const FractionalOffset(0.0, 0.0),
                              // end: const FractionalOffset(1.0, 0.0),
                              //  tileMode: TileMode.clamp,
                              // ),
                              // borderRadius: BorderRadius.only(
                              //     bottomLeft: Radius.circular(20),
                              //     bottomRight: Radius.circular(20))
                            ),
                            child:
                                //   AnimatedTextKit(
                                //     isRepeatingAnimation : false,
                                //   animatedTexts: [
                                //     TypewriterAnimatedText(desc,speed:Duration(milliseconds: 50),textAlign: TextAlign.start, textStyle: GoogleFonts.workSans(
                                //       fontWeight: FontWeight.w400,
                                //       fontSize: 12,
                                //       color: Colors.white70,
                                //     ),),
                                //   ],
                                // ),
                                Text(
                              desc,
                              maxLines: 3,
                              style: GoogleFonts.workSans(
                                textStyle: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 5.0,
                                        color: Colors.black),
                                    Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 5.0,
                                        color: Colors.black),
                                  ],
                                ),
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ]),
                  ]),
              //   ],
              // ),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [Colors.transparent, Colors.grey[900]],
                //   // begin: const FractionalOffset(0.0, 0.0),
                //   // end: const FractionalOffset(1.0, 0.0),
                //   //  tileMode: TileMode.clamp,
                // ),
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                // border: Border.all(width: 1,color: Colors.black)
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                  //
                  // child:
                 
                  children: <Widget>[
                    Container(
                      // margin:EdgeInsets.only(top:10),
                      width: MediaQuery.of(context).size.width-80,
                      // alignment: Alignment.centerLeft,
                        child: Text(author==null?"":
                      author,
                      // textAlign: TextAlign.center,
                      style: GoogleFonts.workSans(
                        textStyle: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                                offset: Offset(0.0, 0.0),
                                blurRadius: 5.0,
                                color: Colors.black),
                            Shadow(
                                offset: Offset(0.0, 0.0),
                                blurRadius: 5.0,
                                color: Colors.black),
                          ],
                        ),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    )),
                    IconButton(
                        padding: EdgeInsets.only(right: 30),
                        // iconSize: ,
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          saved
                              ? setState(() {
                                  deleteNews(context);
                                  // _loading = true;
                                })
                              : setState(() {
                                  saveNews(context);
                                  // checksaved();
                                  // _loading = true;
                                });
                          // liked = !liked;
                        },
                        icon: Icon(
                            saved ? Icons.bookmark : Icons.bookmark_outline,
                            size: 26,
                            color: Colors.white70))
                  ])),
          // _loading
          //     ? Center(
          //         child: LinearProgressIndicator(
          //           minHeight: 2,
          //           backgroundColor: Colors.transparent,
          //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //         ),
          //         )
          //     : Center(),
        ]),
      ),
    );
  }
}
