import 'package:flutter/material.dart';
import 'package:sanjay_notes/routes.dart';

import 'data_manager.dart';
import 'list_model.dart';
import 'note.dart';

class LabelScreen extends StatefulWidget {
  final List<Note> notesForLabel;
  final List<ListModel> listModelForLabel;

  LabelScreen({
    super.key,
    required this.notesForLabel,
    required this.listModelForLabel,
  });

  @override
  State<LabelScreen> createState() => _LabelScreenState();
}

class _LabelScreenState extends State<LabelScreen> {
  TextEditingController controller = TextEditingController();
  List<String> selectedLabels = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQueryData().padding.top + 40),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.arrow_back),
                      ),
                      onTap: () {
                        debugPrint("_LabelScreenState: build check");
                        for (int i = 0; i < selectedLabels.length; i++) {
                          for (Note note in widget.notesForLabel) {
                            if (!note.labels.contains(selectedLabels[i])) {
                              note.labels.add(selectedLabels[i]);
                              debugPrint("_LabelScreenState: build check ${note.labels} $i ");
                            }
                          }
                        }
                        for (int i = 0; i < selectedLabels.length; i++) {
                          debugPrint("_LabelScreenState: build check 2nd ${widget.listModelForLabel.length}");
                          for (ListModel listModel in widget.listModelForLabel) {
                            debugPrint("_LabelScreenState: build ${selectedLabels.length}");
                            if (!listModel.labels.contains(selectedLabels[i])) {
                              listModel.labels.add(selectedLabels[i]);
                              debugPrint("_LabelScreenState: build ${listModel.labels} $i");
                            }
                            debugPrint("_LabelScreenState: build wefbweyfgcyehvbcfyfewbfchewb");
                          }
                        }

                        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter label name',
                            hintStyle: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          for (int i = DataManager().labels.length - 1; i >= 0; i--)
            LabelTile(
              label: DataManager().labels[i],
              selectedLabels: selectedLabels,
            ),
        ],
      ),
    );
  }
}

class LabelTile extends StatefulWidget {
  final List<String> selectedLabels;
  final String label;

  const LabelTile({super.key, required this.label, required this.selectedLabels});

  @override
  State<LabelTile> createState() => _LabelTileState();
}

class _LabelTileState extends State<LabelTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              child: Text(widget.label),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {
              if (widget.selectedLabels.contains(widget.label)) {
                widget.selectedLabels.remove(widget.label);
              } else {
                widget.selectedLabels.add(widget.label);
              }
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: widget.selectedLabels.contains(widget.label)
                  ? Icon(
                      Icons.check_box,
                      color: Colors.blue.shade700,
                    )
                  : Icon(Icons.check_box_outline_blank),
            ),
          ),
        ],
      ),
    );
  }
}
