import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:receipeapp/model/recipe_model.dart';
import 'package:receipeapp/views/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> _recipies = <RecipeModel>[];
  String? ingridients;
  bool _loading = false;

  String query = "";

  TextEditingController _controller = TextEditingController();

  String applicatonID = "ac42160b";
  String applicationKEY = "831990fc246ee486fd8fbb1d5f276d98";

  getRecipes(String query) async {
    setState(() {
      _loading = true;
    });
    _recipies = [];

    String _url =
        "https://api.edamam.com/search?q=$query&app_id=ac42160b&app_key=831990fc246ee486fd8fbb1d5f276d98";

    var response = await http.get(Uri.parse(_url));
    print("$response this is response");

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    print("this is json data $jsonData");

    jsonData["hits"].forEach((element) {
      print(element.toString());
      RecipeModel _recipiesModel = RecipeModel();

      _recipiesModel = RecipeModel.fromMap(element['recipe']);

      _recipies.add(_recipiesModel);
      print(_recipiesModel.url);
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff213A50), Color(0xff071930)],
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft,
              ),
            ),
          ),
          Container(
            // color: Colors.teal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'AppGuy',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Recipes',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const Text(
                    "What will you cook today ? ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    "Just Enter Ingredients you have and we will show the best recipe for you",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.white,
                            controller: _controller,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter Ingridients",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_controller.text.isNotEmpty) {
                              getRecipes(_controller.text);
                              print("just do it");
                            } else {
                              print("Just don't do it");
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffA2834D),
                                  Color(0xffBC9A5F),
                                ],
                                begin: FractionalOffset.topRight,
                                end: FractionalOffset.bottomLeft,
                              ),
                            ),
                            child: const Icon(Icons.search),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  (_loading)
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    mainAxisSpacing: 30.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            children: List.generate(
                                _recipies.length,
                                (index) => GridTile(
                                      child: RecipieTile(
                                          title: _recipies[index].label!,
                                          imgUrl: _recipies[index].image!,
                                          description: _recipies[index].source!,
                                          url: _recipies[index].url!),
                                    )),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipieTile extends StatefulWidget {
  final String title, description, imgUrl, url;
  const RecipieTile(
      {super.key,
      required this.title,
      required this.description,
      required this.imgUrl,
      required this.url});

  @override
  State<RecipieTile> createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  Future<void> _loadwebsite() async {
    var finalurl = widget.url.replaceAll("http", "https");
    var _url = Uri.parse(finalurl);
    try {
      launchUrl(_url);
      print("YOur url launch successfully $_url");
    } catch (e) {
      print("Your Error is ***** $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: _loadwebsite,
          child: Container(
              margin: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Image.network(
                    widget.imgUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(
                        // color: Colors.teal,
                        gradient: LinearGradient(
                      colors: [
                        Colors.white30,
                        Colors.white,
                      ],
                      begin: FractionalOffset.centerRight,
                      end: FractionalOffset.centerLeft,
                    )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            widget.description,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                fontFamily: 'OverpassRegular'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        )
      ],
    );
  }
}
