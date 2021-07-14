import 'dart:async';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  final String postUrl;
  ArticleView({@required this.postUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

   share(msg) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(msg,sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(
      //   child: Container(
      //     // decoration: BoxDecoration(color: Colors.black87),
      //     color: Colors.black87,
      //     // color: Colors.black87,
      //     child: Column(
      //       children: <Widget>[
      //         UserAccountsDrawerHeader(
      //             decoration: BoxDecoration(
      //               // gradient: LinearGradient(
      //               //     begin: Alignment.topCenter,
      //               //     end: Alignment.bottomCenter,
      //               //     colors: [Colors.blueGrey[300], Colors.blueGrey[900]]),
      //               color: Colors.blueGrey[900],
      //             ),
      //             currentAccountPicture: profile == null
      //                 ? CircleAvatar(
      //                     backgroundColor: Colors.white,
      //                     child: Text(
      //                       value.substring(0, 1),
      //                       style: TextStyle(fontSize: 40.0),
      //                     ),
      //                   )
      //                 : CircleAvatar(
      //                     radius: 40,
      //                     backgroundImage: NetworkImage(profile),
      //                   ),
      //             accountName: Text(
      //               value,
      //               style: GoogleFonts.workSans(
      //                 fontWeight: FontWeight.w500,
      //                 fontSize: 17,
      //                 color: Colors.white,
      //               ),
      //             ),
      //             accountEmail: Text(
      //               email,
      //               style: GoogleFonts.workSans(
      //                 fontWeight: FontWeight.w400,
      //                 fontSize: 13,
      //                 color: Colors.white70,
      //               ),
      //             )),
      //         ListTile(
      //           shape: Border(
      //             // top: BorderSide(
      //             //   color: Colors.black,
      //             //   width: 1),
      //             bottom: BorderSide(
      //               color: Colors.black,
      //               width: 1,
      //             ),
      //           ),
      //           // Border.symmetric( vertical: BorderSide.none,horizontal: BorderSide(color: Colors.black, width: 3),),
      //           //   color: Colors.black, style: BorderStyle.solid),
      //           leading: Icon(Icons.home, color: Colors.white),
      //           title: Text(
      //             'Home',
      //             style: GoogleFonts.workSans(
      //               fontWeight: FontWeight.w500,
      //               fontSize: 17,
      //               color: Colors.white,
      //             ),
      //           ),
      //           onTap: () => {Navigator.of(context).pop()},
      //         ),
      //         ListTile(
      //           // leading: Icon(Icons.exit_to_app),
      //           // title: Text('Logout'),
      //           // onTap: () => {Navigator.of(context).pop()},
      //           shape: Border(
      //             bottom: BorderSide(
      //               color: Colors.black,
      //               width: 1,
      //             ),
      //           ),
      //           onTap: () => _signOut(context),
      //           title: Text(
      //             'Logout',
      //             style: GoogleFonts.workSans(
      //               fontWeight: FontWeight.w500,
      //               fontSize: 17,
      //               color: Colors.white,
      //             ),
      //           ),
      //           leading: Icon(
      //             Icons.logout,
      //             color: Colors.white,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      // appBar: AppBar(

      //   centerTitle: true,
      //   title:
      //     Text(
      //       'News',
      //       style: GoogleFonts.workSans(
      //         fontWeight: FontWeight.w500,
      //         fontSize: 24,
      //         color: Colors.white,
      //       ),
      //     ),
      //   backgroundColor: Colors.blueGrey[900],
      // ),
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
        actions: <Widget>[
          // Opacity(
          //  opacity:0,
          //  child:
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => {share(widget.postUrl)},
          )
        ],
        backgroundColor: Colors.blueGrey[900],
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.postUrl,
          // javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
            return Scaffold(
              backgroundColor: Colors.blueGrey[900],
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
