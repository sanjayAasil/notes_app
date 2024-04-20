import 'package:flutter/material.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/routes.dart';

import 'data_manager.dart';

import 'note.dart';

class LabelScreen extends StatefulWidget {
  final List<String> selectedIds;

  const LabelScreen({super.key, required this.selectedIds});

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
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      onTap: onBackPress,
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

  onBackPress() {
    for (int i = 0; i < selectedLabels.length; i++) {
      for (Note note in DataManager().notes) {
        if (widget.selectedIds.contains(note.id)) {
          if (!note.labels.contains(selectedLabels[i])) {
            note.labels.add(selectedLabels[i]);
          }
        }
      }
      for (Note note in DataManager().archivedNotes) {
        if (widget.selectedIds.contains(note.id)) {
          if (!note.labels.contains(selectedLabels[i])) {
            note.labels.add(selectedLabels[i]);
          }
        }
      }
      for (Note note in DataManager().pinnedNotes) {
        if (widget.selectedIds.contains(note.id)) {
          if (!note.labels.contains(selectedLabels[i])) {
            note.labels.add(selectedLabels[i]);
          }
        }
      }
      for (ListModel listModel in DataManager().listModels) {
        if (widget.selectedIds.contains(listModel.id)) {
          if (!listModel.labels.contains(selectedLabels[i])) {
            listModel.labels.add(selectedLabels[i]);
          }
        }
      }
      for (ListModel listModel in DataManager().archivedListModels) {
        if (widget.selectedIds.contains(listModel.id)) {
          if (!listModel.labels.contains(selectedLabels[i])) {
            listModel.labels.add(selectedLabels[i]);
          }
        }
      }
      for (ListModel listModel in DataManager().pinnedListModels) {
        if (widget.selectedIds.contains(listModel.id)) {
          if (!listModel.labels.contains(selectedLabels[i])) {
            listModel.labels.add(selectedLabels[i]);
          }
        }
      }
    }
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
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
            child: Icon(
              Icons.label_outline_rounded,
              color: Colors.grey.shade800,
            ),
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
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey.shade800,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
