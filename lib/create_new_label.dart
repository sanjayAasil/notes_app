import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/label_db.dart';
import 'package:sanjay_notes/my_drawer.dart';
import 'package:sanjay_notes/routes.dart';

class CreateNewLabelScreen extends StatefulWidget {
  const CreateNewLabelScreen({super.key});

  @override
  State<CreateNewLabelScreen> createState() => _CreateNewLabelScreenState();
}

class _CreateNewLabelScreenState extends State<CreateNewLabelScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) {
        if (controller.text.isNotEmpty && !DataManager().labels.contains(controller.text.trim())) {
          LabelsDb.addLabel(LabelsDb.labelsKey, controller.text.trim());
          setState(() {});
        }
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      },
      child: Scaffold(
        drawer: const MyDrawer(selectedTab: 'createNewLabelScreen'),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: const MediaQueryData().padding.top + 50),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (controller.text.isNotEmpty && !DataManager().labels.contains(controller.text.trim())) {
                        LabelsDb.addLabel(LabelsDb.labelsKey, controller.text.trim());
                        setState(() {});
                      }
                      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Edit labels',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(40),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.plus,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: ' Create new label',
                      hintStyle: TextStyle(fontWeight: FontWeight.w300),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (controller.text.isNotEmpty && !DataManager().labels.contains(controller.text.trim())) {
                      LabelsDb.addLabel(LabelsDb.labelsKey, controller.text.trim());
                      controller.clear();
                      setState(() {});
                    }
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check_box_outlined,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
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
                                child: Icon(
                                  Icons.label_outline_rounded,
                                  color: Colors.grey.shade800,
                                ),
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
                                  child: Icon(
                                    CupertinoIcons.pen,
                                    color: Colors.grey.shade800,
                                  ),
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
      ),
    );
  }
}
