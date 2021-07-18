import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:researchfin/controller/api_call.dart';
import 'package:researchfin/models/search_data.dart';
import 'package:researchfin/widgets/home_body.dart';
import 'package:researchfin/widgets/search_bar.dart';

import '../controller/searching_provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  ApiCallProvider _apiCallProvider = ApiCallProvider();
  String pattern = "";

  // bool searching = false;
  String selectedSymbol = "";

  @override
  void initState() {
    _searchController.addListener(textTypingListener);
    super.initState();
  }

  textTypingListener() async {
    if (_searchController.text.trim().length > 0) {
      Provider.of<SearchingProvider>(context, listen: false).changeSearch(true);
    } else {
      Provider.of<SearchingProvider>(context, listen: false)
          .changeSearch(false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Consumer<SearchingProvider>(
              builder: (context, providerClass, _) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: constraints.maxWidth / 2,
                            child: Center(
                              child: Text(
                                'Search Stock Symbol',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // decoration: BoxDecoration(
                            //     border: Border.all(
                            //   color: Colors.white,
                            // ),),
                            child: SearchBar(
                              width: constraints.maxWidth / 2,
                              controller: _searchController,
                              focusNode: _focusNode,
                            ),
                          ),
                        ],
                      ),
                      providerClass.searching
                          ? FutureBuilder(
                              future: _apiCallProvider
                                  .searchStock(_searchController.text),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  List<BestMatches> dropdownItems =
                                      snapshot.data;
                                  if (dropdownItems.length > 0) {
                                    return Container(
                                      height: constraints.maxHeight / 1.5,
                                      child: ListView.builder(
                                        itemCount: dropdownItems.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            onTap: () {
                                              setState(() {
                                                selectedSymbol =
                                                    dropdownItems[index]
                                                        .s1Symbol;
                                                _searchController.text =
                                                    dropdownItems[index]
                                                        .s1Symbol;
                                                providerClass.searching = false;
                                                FocusScope.of(context)
                                                    .unfocus();
                                              });
                                            },
                                            title: Text(
                                              "${dropdownItems[index].s1Symbol}",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "${dropdownItems[index].s2Name}",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: constraints.maxHeight / 1.5,
                                      child: ListView.builder(
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            onTap: () {
                                              setState(() {
                                                providerClass.searching = false;
                                                _searchController.clear();
                                                FocusScope.of(context)
                                                    .unfocus();
                                              });
                                            },
                                            title: Text(
                                              "No Result !",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            )
                          : _searchController.text.isEmpty
                              ? Container(
                                  height: constraints.maxHeight * 0.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Hi ! My Name is Abhinav Kumar Sintoo.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Start your search by typing on above search bar",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : HomePageBody(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  stockSymbol: selectedSymbol,
                                )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
