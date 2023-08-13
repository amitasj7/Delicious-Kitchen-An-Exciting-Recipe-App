import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  final String postUrl;

  const RecipeView({super.key, required this.postUrl});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

/* 
class _RecipeViewState extends State<RecipeView> {
  InAppWebViewController? _webViewController;
  PullToRefreshController? _refreshController;

  late var _url;
  double progress = 0;
  var _urlController = TextEditingController();
  String? finalUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalUrl = widget.postUrl;
    if (widget.postUrl.contains('http://')) {
      finalUrl = widget.postUrl.replaceAll('http://', 'https://');
      print(finalUrl! + "this is final url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
        title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _urlController,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                hintText: 'Your Url ',
                prefixIcon: Icon(Icons.search),
                focusColor: Colors.white,
              ),
            )),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Container(
     
      )
/*       
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(finalUrl!)),
              ),
            )
          ],
        ),
      ),
   */
    );
  }
}
 */

class _RecipeViewState extends State<RecipeView> {
  late String finalUrl;
  var _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalUrl = widget.postUrl;
    if (widget.postUrl.contains('http://')) {
      finalUrl = widget.postUrl.replaceAll('http://', 'https://');
      print(finalUrl + "this is final url");
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Color.fromARGB(0, 207, 224, 48))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(finalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                right: 24,
                left: 24,
                bottom: 16,
                top: 60,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff213A50), Color(0xff071930)],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft),
              ),
              child: const Row(
                mainAxisAlignment:
                    kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Text(
                    "AppGuy",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Overpass'),
                  ),
                  Text(
                    "Recipes",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontFamily: 'Overpass'),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return WebViewWidget(controller: _controller);
                },
              )),
            )
          ],
        ),
      ),
    );
  }
}
