import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: 60,
            alignment: AlignmentDirectional.centerStart,
            color: Colors.grey.shade300,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    debugPrint("SearchScreen: build ");
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search your notes',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // SizedBox(),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
