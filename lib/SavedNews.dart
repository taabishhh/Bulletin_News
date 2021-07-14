import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'HomePage.dart';
import 'Login.dart';
import 'NewsTile.dart';
import 'Article.dart';
import 'Register.dart';

class SavedNews extends StatefulWidget {
  Saved createState() => Saved();
}

List<Article> newslists = [];
bool saveview = false;
final User user = FirebaseAuth.instance.currentUser;
//final uid = user.uid;
final databaseReference = FirebaseFirestore.instance;

class Saved extends State<SavedNews> {
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    newslists.clear();
    getSavedNews();
  }

  Future<void> getSavedNews() async {
    var snapshot = await databaseReference
        .collection("users")
        .doc(user.uid)
        .collection('saved_news')
        .get(); //.then((querySnapshot)=>{
    //     querySnapshot.docs.forEach((doc) => {
    //  newslist.push(doc.data())
    //   })
    snapshot.docs.forEach((doc) {
      Article article = Article(
        title: doc.data()['title'].toString(),
        // author: querySnapshot.docs.map((doc)=> doc.get('title')).toString(),
        description: doc.data()['description'].toString(),
        urlToImage: doc.data()['imgUrl'].toString(),
        // publshedAt: DateTime.utc(1944, 6, 6),
        content: doc.data()['content'].toString(),
        articleUrl: doc.data()['posturl'].toString(),
      );
      newslists.add(article);
      // newslist = querySnapshot.docs.map((doc)=> doc.get('title'))
    });
    // print(newslists);
    // newslist=snapshot.docs.map((doc) => doc.data());
    setState(() {
      _loading = false;
    });
  }

  Future<void> deleteAllNews(BuildContext context) async {
    try {
      await databaseReference
          .collection("users")
          .doc(user.uid)
          .collection('saved_news')
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      displayToastMessage('All deleted', context);
      if (mounted) {
        setState(() {
          _loading = false;
          newslists.clear();
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
  }

  @override
  Widget build(BuildContext context) {
    saveview = true;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // final User user = FirebaseAuth.instance.currentUser;
    // final uid = user.uid;
    // String profile;
    // final List datalist=[];
    // String profile='';
    // String name=uid.name;
    // DatabaseReference dbRef =
    //     FirebaseDatabase.instance.reference().child('users');

    // return FutureBuilder(
    //     //future: dbRef.orderByKey().equalTo(uid).orderByChild('name').once(),
    //     future: dbRef.child(uid).once(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         // String keys = snapshot.data.value.key;
    //         value = snapshot.data.value['name'];
    //         email = snapshot.data.value['email'];
    //         profile = snapshot.data.value['profile'];
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            // decoration: BoxDecoration(color: Colors.black87),
            color: Colors.black87,
            // color: Colors.black87,
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
                      color: Colors.blueGrey[900],
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
                  leading: Icon(Icons.home_outlined, color: Colors.white),
                  title: Text(
                    'Home',
                    style: GoogleFonts.workSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage())),
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
                  leading: Icon(Icons.bookmarks_outlined, color: Colors.white),
                  title: Text(
                    'Saved',
                    style: GoogleFonts.workSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () => {Navigator.of(context).pop()},
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
          title: RichText(
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
                  ),
          backgroundColor: Colors.blueGrey[900],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 4),
          // color: Colors.black26,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter:
                  new ColorFilter.mode(Colors.black54, BlendMode.overlay),
              image: AssetImage("assets/images/newsbg2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(
                    //minHeight: 2,
                    strokeWidth: 3,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Column(
                  children: [
                    Container(
                        // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1, color: Colors.white)),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: TextButton(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Remove All ',
                                  style: GoogleFonts.workSans(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    backgroundColor: Colors.transparent,
                                    // letterSpacing: 0.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.delete_forever, color: Colors.red)
                              ]),
                          onPressed: () => setState(() {
                            deleteAllNews(context);
                          }),
                        )),
                    Container(
                      // color: Colors.black,
                      height: MediaQuery.of(context).size.height - 150,
                      child: ListView.builder(
                          itemCount: newslists.length,
                          // shrinkWrap: true,
                          // physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            // checksaved(newslist[index].title, context);
                            // print(newslist);
                            // saved = false;
                            return NewsTile(
                              // saved: saved,
                              imgUrl: newslists[index].urlToImage ?? "",
                              title: newslists[index].title ?? "",
                              desc: newslists[index].description ?? "",
                              content: newslists[index].content ?? "",
                              posturl: newslists[index].articleUrl ?? "",
                            );
                          }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

Future<void> _signOut(BuildContext context) async {
  // FirebaseAuth.instance.currentUsper.delete();
  await FirebaseAuth.instance.signOut();
  Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => Login()));
}
