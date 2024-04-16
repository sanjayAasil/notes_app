import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/my_drawer.dart';
import 'package:sanjay_notes/routes.dart';

class CreateNewLabelScreen extends StatefulWidget {
  CreateNewLabelScreen({super.key});

  @override
  State<CreateNewLabelScreen> createState() => _CreateNewLabelScreenState();
}

class _CreateNewLabelScreenState extends State<CreateNewLabelScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(selectedTab: 'createNewLabelScreen'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQueryData().padding.top + 45),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (controller.text.isNotEmpty && !DataManager().labels.contains(controller.text.trim())) {
                      DataManager().labels.add(controller.text.trim());
                      setState(() {});
                    }
                    Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Edit labels',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            children: [
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(40),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.plus),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: ' Create new label',
                    hintStyle: TextStyle(fontWeight: FontWeight.w300),
                    border: InputBorder.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (controller.text.isNotEmpty && !DataManager().labels.contains(controller.text.trim())) {
                    DataManager().labels.add(controller.text.trim());
                    controller.clear();
                    setState(() {});
                  }
                },
                borderRadius: BorderRadius.circular(40),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.check_box_outlined),
                ),
              ),
            ],
          ),
          Divider(),
          if (DataManager().labels.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = DataManager().labels.length - 1; i >= 0; i--)
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.label_outline_rounded),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(DataManager().labels[i]),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(40),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(CupertinoIcons.pen),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
