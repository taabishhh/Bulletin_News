import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'News.dart';
import 'Article.dart';
import 'NewsTile.dart';
import 'Login.dart';
import 'NewsForCategory.dart';
import 'Register.dart';
import 'SavedNews.dart';
import 'GetSearchedNews.dart';

var newslist;
String value, email, profile;
String selectedCategory;
bool categ = false, searchpressed = false;
String searchedData = "";

final categories = [
  'general',
  'technology',
  'business',
  'entertainment',
  'health',
  'science',
  'sports'
];

class HomePage extends StatefulWidget {
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      'homepage': (context) => HomePage(),
      'login': (context) => Login(),
    });
  }

  Home createState() => Home();
}

class Home extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _loading = true;
  bool saved = false;
  // bool category = false;

  Article ar = Article();
  @override
  void initState() {
    super.initState();
    getNews();
    //  WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  Future<void> getNews() async {
    setState(() {
      searchedData = '';
      _loading = true;
      searchpressed = false;
    });
    News news = News();
    await news.getNews();
    newslist = news.news;
    // getCatNews('all');
    // print(newslist);
    setState(() {
      selectedCategory = '';
      categ = false;
      _loading = false;
    });
  }

  Future<void> getCatNews() async {
    setState(() {
      searchedData = '';
      _loading = true;
      searchpressed = false;
    });
    NewsForCategory news = NewsForCategory();
    await news.getNewsForCategory(selectedCategory);
    newslist = news.news;

    setState(() {
      categ = true;
      _loading = false;
    });
  }

  Future<void> getSearchedNews() async {
    setState(() {
      searchpressed = false;
      _loading = true;
    });
    GetSearchedNews news = GetSearchedNews();
    await news.getSearchedNews(searchedData);
    newslist = news.news;
    // getCatNews('all');
    // print(newslist);
    setState(() {
      selectedCategory = '';
      categ = false;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _filter = TextEditingController();

    var appBarTitle = new TextField(
        enableSuggestions: true,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Colors.grey,
        style: GoogleFonts.workSans(
          fontWeight: FontWeight.w400,
          fontSize: 17,
          color: Colors.white,
        ),
        // controller: _filter,
        decoration: new InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          prefixIcon: new Icon(Icons.search, color: Colors.grey[400], size: 20),
          hintText: 'Search for topics...',
          hintStyle: GoogleFonts.workSans(
            fontWeight: FontWeight.w400,
            fontSize: 17,
            color: Colors.grey[400],
          ),
        ),
        onSubmitted: (data) {
          if (data != null && data.isNotEmpty) {
            setState(() {
              searchedData = data;
// _fetchNewsHeadlines(data, true);
              getSearchedNews();
              print(data);
            });
          }
        });
    saveview = false;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;

    // final List datalist=[];
    // String profile='';
    // String name=uid.name;
    DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child('users');

    return FutureBuilder(
        //future: dbRef.orderByKey().equalTo(uid).orderByChild('name').once(),
        future: dbRef.child(uid).once(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // String keys = snapshot.data.value.key;
            value = snapshot.data.value['name'];
            email = snapshot.data.value['email'];
            profile = snapshot.data.value['profile'];
            return SafeArea(
              child: Scaffold(
                drawer: Drawer(
                  child: Container(
                    // decoration: BoxDecoration(color: Colors.black87),
                    color: Colors.black87,
                    child: Column(
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black54, BlendMode.darken),
                                image: AssetImage("assets/images/newsbg2.jpg"),
                                fit: BoxFit.cover,
                              ),

                              // gradient: LinearGradient(
                              //     begin: Alignment.topCenter,
                              //     end: Alignment.bottomCenter,
                              //     colors: [Colors.blueGrey[300], Colors.blueGrey[900]]),
                              // color: Colors.blueGrey[900],
                            ),
                            currentAccountPicture: profile == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      value.substring(0, 1),
                                      style: TextStyle(fontSize: 40.0),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(profile),
                                  ),
                            accountName: Text(
                              value,
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
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                            accountEmail: Text(
                              email,
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
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            )),
                        ListTile(
                          // tileColor: Colors.blueGrey[900],
                          shape: Border(
                            // top: BorderSide(
                            //   color: Colors.black,
                            //   width: 1),
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          // Border.symmetric( vertical: BorderSide.none,horizontal: BorderSide(color: Colors.black, width: 3),),
                          //   color: Colors.black, style: BorderStyle.solid),
                          leading:
                              Icon(Icons.home_outlined, color: Colors.white),
                          title: Text(
                            'Home',
                            style: GoogleFonts.workSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () => {Navigator.of(context).pop()},
                        ),
                        ListTile(
                          shape: Border(
                            // top: BorderSide(
                            //   color: Colors.black,
                            //   width: 1),
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          // Border.symmetric( vertical: BorderSide.none,horizontal: BorderSide(color: Colors.black, width: 3),),
                          //   color: Colors.black, style: BorderStyle.solid),
                          leading: Icon(Icons.bookmarks_outlined,
                              color: Colors.white),
                          title: Text(
                            'Saved',
                            style: GoogleFonts.workSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SavedNews())),
                        ),
                        ListTile(
                          // leading: Icon(Icons.exit_to_app),
                          // title: Text('Logout'),
                          // onTap: () => {Navigator.of(context).pop()},
                          shape: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          onTap: () => _signOut(context),
                          title: Text(
                            'Logout',
                            style: GoogleFonts.workSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          leading: Icon(
                            Icons.logout_sharp,
                            color: Colors.white,
                          ),
                        ),
                        ListTile(
                          // shape: Border(
                          //   bottom: BorderSide(
                          //     color: Colors.black,
                          //     width: 1,
                          //   ),
                          // ),
                          onTap: null,
                          title: Text(
                            'Developed and designed by \nTaabish Sutriwala',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.workSans(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                appBar: AppBar(
                    centerTitle: true,
                    title: !searchpressed
                        ? new RichText(
                            text: TextSpan(
                              // text: 'Bulletin ',
                              children: [
                                TextSpan(
                                  text: 'B',
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'u',
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Colors.white70,
                                  ),
                                ),
                                TextSpan(
                                  text: 'll',
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'e',
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Colors.white70,
                                  ),
                                ),
                                TextSpan(
                                  text: 't',
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'in ',
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Colors.white70,
                                  ),
                                ),
                                WidgetSpan(
                                  child: Image.asset('assets/images/BNlogo.png',
                                      scale: 20),
                                ),
                                TextSpan(
                                  text: ' N',
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'e',
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Colors.white70,
                                  ),
                                ),
                                TextSpan(
                                  text: 'ws    ',
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : appBarTitle,
                    backgroundColor: Colors.blueGrey[900],
                    actions: [
                      IconButton(
                          icon: searchpressed
                              ? Icon(Icons.close)
                              : Icon(Icons.search),
                          onPressed: (() {
                            if (!searchpressed) {
                              setState(() {
                                searchpressed = true;
                                // _loading = true;
                              });
                            } else {
                              setState(() {
                                searchpressed = false;
                                _filter.clear();
                                // _loading = false;
                              });
                            }
                          }))
                    ]),
                body: SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height - 80,
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                        color: Colors.black,
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //     colorFilter: new ColorFilter.mode(
                        //         Colors.black54, BlendMode.overlay),
                        //     image: AssetImage("assets/images/newsbg2.jpg"),
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        child: Container(
                            child: Column(children: <Widget>[
                          Row(children: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  getNews();
                                  // _loading = true;
                                });
                              },
                              child: Row(children: <Widget>[
                                Text(
                                  'Trending',
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                ),
                              ]),
                            ),
                            Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width - 112,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  return selectedCategory != categories[index]
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5, bottom: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3),
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white)),
                                          child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedCategory =
                                                      categories[index];
                                                  getCatNews();
                                                  // _loading = true;
                                                });
                                              },
                                              child: Text(
                                                categories[index][0]
                                                        .toUpperCase() +
                                                    categories[index].substring(
                                                      1,
                                                    ),
                                                style: GoogleFonts.workSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5, bottom: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3),
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white)),
                                          child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedCategory =
                                                      categories[index];
                                                  getCatNews();
                                                  // _loading = true;
                                                  //CategoryNews(newsCategory:categories[index]);
                                                });
                                              },
                                              child: Text(
                                                categories[index][0]
                                                        .toUpperCase() +
                                                    categories[index].substring(
                                                      1,
                                                    ),
                                                style: GoogleFonts.workSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                              )),
                                        );
                                },
                              ),
                            ),
                          ]),
                          searchedData != ""
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Search results for \'' +
                                        searchedData +
                                        '\'',
                                    style: GoogleFonts.workSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ))
                              : Center(),
                          RefreshIndicator(
                            key: _refreshIndicatorKey,
                            onRefresh: //getNews,
                                !searchpressed
                                    ? categ
                                        ? getCatNews
                                        : getNews
                                    : getSearchedNews,
                            color: Colors.white,
                            backgroundColor: Colors.blueGrey[900],
                            child: searchpressed
                                ? Center()
                                : Container(
                                    child: _loading
                                        ? Center(
                                            child: LinearProgressIndicator(
                                              minHeight: 2,
                                              backgroundColor:
                                                  Colors.transparent,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : Container(
                                            // color: Colors.black,

                                            height: searchedData != ""
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    174
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    148,
                                            child: newslist.length == 0
                                                ? displayToastMessage(
                                                    'Nothing found', context)
                                                : ListView.builder(
                                                    itemCount: newslist.length,
                                                    // shrinkWrap: true,
                                                    // physics: ClampingScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      // checksaved(newslist[index].title, context);
                                                      // print(newslist);
                                                      // saved = false;
                                                      return NewsTile(
                                                        // saved: saved,
                                                        imgUrl: newslist[index]
                                                                .urlToImage ??
                                                            "",
                                                        title: newslist[index]
                                                                .title ??
                                                            "",
                                                        author: newslist[index]
                                                                .author ??
                                                            null,
                                                        desc: newslist[index]
                                                                .description ??
                                                            "",
                                                        content: newslist[index]
                                                                .content ??
                                                            "",
                                                        // publishedAt: newslist[index]
                                                        //         .publishedAt ??
                                                        //     "",
                                                        posturl: newslist[index]
                                                                .articleUrl ??
                                                            "",
                                                      );
                                                    }),
                                          ),
                                  ),
                          ),
                        ])))),
              ),
            );
          }
          return SafeArea(
              child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter:
                    new ColorFilter.mode(Colors.black54, BlendMode.overlay),
                image: AssetImage("assets/images/newsbg2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ));
        });
  }

  final User user = FirebaseAuth.instance.currentUser;
  //final uid = user.uid;
  final databaseReference = FirebaseFirestore.instance;
  void checksaved(index, BuildContext context) async {
    //add index argument

    try {
      // ignore: await_only_futures
      var snap = await databaseReference
          .collection("users")
          .doc(user.uid)
          .collection('saved_news')
          .where('title', isEqualTo: index)
          .get(); //((result) => {
      // print(value.data.contains(title));
      // for(var doc in snap.docs) {
      if (snap.docs != null && snap.docs.isNotEmpty) {
        // if (mounted) {
        //   setState(() => {saved = true});
        // }
        saved = true;
        // print(index);
      } else {
        // if (mounted) {
        //   setState(() => {saved = false});
        // }
        saved = false;
        // print('false');
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
}

Future<void> _signOut(BuildContext context) async {
  // FirebaseAuth.instance.currentUsper.delete();
  await FirebaseAuth.instance.signOut();
  Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => Login()));
}
