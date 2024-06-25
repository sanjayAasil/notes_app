import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/Database/data_manager.dart';
import 'package:sanjay_notes/models/note.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:sanjay_notes/utils.dart';
import 'models/list_model.dart';

class NoteTileListView extends StatefulWidget {
  final List<String> selectedIds;
  final Note note;
  final Function()? onUpdateRequest;

  const NoteTileListView({
    Key? key,
    required this.note,
    required this.selectedIds,
    this.onUpdateRequest,
  }) : super(key: key);

  @override
  State<NoteTileListView> createState() => _NoteTileListViewState();
}


class _NoteTileListViewState extends State<NoteTileListView> {
  late bool isTimePassed;

  @override
  void initState() {
    if (widget.note.scheduleTime != null) {
      isTimePassed = DateTime.now().isAfter(widget.note.scheduleTime!);
    } else {
      isTimePassed = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<DataManager>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (widget.selectedIds.isEmpty) {
            Navigator.of(context).pushNamed(Routes.editOrViewNoteScreen, arguments: widget.note);
          } else {
            if (widget.selectedIds.contains(widget.note.id)) {
              widget.selectedIds.remove(widget.note.id);
            } else {
              widget.selectedIds.add(widget.note.id);
            }
            widget.onUpdateRequest?.call();
          }
        },
        onLongPress: () {
          if (widget.selectedIds.contains(widget.note.id)) {
            widget.selectedIds.remove(widget.note.id);
          } else {
            widget.selectedIds.add(widget.note.id);
          }
          widget.onUpdateRequest?.call();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.note.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: widget.selectedIds.contains(widget.note.id)
                    ? Colors.blue.shade800
                    : widget.note.color == Colors.white
                        ? Colors.grey
                        : Colors.transparent,
                width: widget.selectedIds.contains(widget.note.id) ? 3.0 : 0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        widget.note.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  DataManager().settingsModel.showTimeChecked
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            Utils.getFormattedDateTime(widget.note.createdAt),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 5),
                child: Text(
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  widget.note.note,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.note.scheduleTime != null && !isTimePassed)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.alarm,
                          size: 20,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Text(
                        Utils.getFormattedDateTime(DateTime(
                          widget.note.scheduleTime!.year,
                          widget.note.scheduleTime!.month,
                          widget.note.scheduleTime!.day,
                          widget.note.scheduleTime!.hour,
                          widget.note.scheduleTime!.minute,
                        )),
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              DataManager().settingsModel.showLabelsOnHomeScreen
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Wrap(
                          children: [
                            for (int i = 0; i < widget.note.labels.length; i++)
                              i < 3
                                  ? Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                          child: Text(
                                            '  ${widget.note.labels[i]}  ',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : i == 4
                                      ? Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                              child: Text(
                                                '  +${widget.note.labels.length - 3}  ',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteTileGridView extends StatefulWidget {
  final List<String> selectedIds;
  final Note note;
  final Function()? onUpdateRequest;

  const NoteTileGridView({
    Key? key,
    required this.selectedIds,
    this.onUpdateRequest,
    required this.note,
  }) : super(key: key);

  @override
  State<NoteTileGridView> createState() => _NoteTileGridViewState();
}

class _NoteTileGridViewState extends State<NoteTileGridView> {
  late bool isTimePassed;

  @override
  void initState() {
    if (widget.note.scheduleTime != null) {
      isTimePassed = DateTime.now().isAfter(widget.note.scheduleTime!);
    } else {
      isTimePassed = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<DataManager>();
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 5,
      padding: const EdgeInsets.all(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (widget.selectedIds.isEmpty) {
            Navigator.of(context).pushNamed(Routes.editOrViewNoteScreen, arguments: widget.note);
          } else {
            if (widget.selectedIds.contains(widget.note.id)) {
              widget.selectedIds.remove(widget.note.id);
            } else {
              widget.selectedIds.add(widget.note.id);
            }
            widget.onUpdateRequest?.call();
          }
        },
        onLongPress: () {
          if (widget.selectedIds.contains(widget.note.id)) {
            widget.selectedIds.remove(widget.note.id);
          } else {
            widget.selectedIds.add(widget.note.id);
          }
          widget.onUpdateRequest?.call();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.note.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: widget.selectedIds.contains(widget.note.id)
                    ? Colors.blue.shade800
                    : widget.note.color == Colors.white
                        ? Colors.grey
                        : Colors.transparent,
                width: widget.selectedIds.contains(widget.note.id) ? 3.0 : 0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  DataManager().settingsModel.showTimeChecked
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            Utils.getFormattedDateTime(widget.note.createdAt),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  widget.note.note,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              if (widget.note.scheduleTime != null && !isTimePassed)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.alarm,
                          size: 20,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Text(
                        Utils.getFormattedDateTime(DateTime(
                          widget.note.scheduleTime!.year,
                          widget.note.scheduleTime!.month,
                          widget.note.scheduleTime!.day,
                          widget.note.scheduleTime!.hour,
                          widget.note.scheduleTime!.minute,
                        )),
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              DataManager().settingsModel.showLabelsOnHomeScreen
                  ? Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Wrap(
                        children: [
                          for (int i = 0; i < widget.note.labels.length; i++)
                            i < 3
                                ? Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        '  ${widget.note.labels[i]}  ',
                                      ),
                                    ),
                                  )
                                : i == 4
                                    ? Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                            child: Text(
                                              '  +${widget.note.labels.length - 3}  ',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListModelTileListView extends StatefulWidget {
  final List<String> selectedIds;
  final ListModel listModel;
  final Function? onUpdateRequest;

  const ListModelTileListView({
    Key? key,
    required this.selectedIds,
    required this.listModel,
    this.onUpdateRequest,
  }) : super(key: key);

  @override
  State<ListModelTileListView> createState() => _ListModelTileListViewState();
}

class _ListModelTileListViewState extends State<ListModelTileListView> {
  late bool isTimePassed;

  @override
  void initState() {
    if (widget.listModel.scheduleTime != null) {
      isTimePassed = DateTime.now().isAfter(widget.listModel.scheduleTime!);
    } else {
      isTimePassed = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<DataManager>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (widget.selectedIds.isEmpty) {
            Navigator.of(context).pushNamed(Routes.viewOrEditListModel, arguments: widget.listModel);
          } else {
            if (widget.selectedIds.contains(widget.listModel.id)) {
              widget.selectedIds.remove(widget.listModel.id);
            } else {
              widget.selectedIds.add(widget.listModel.id);
            }
            widget.onUpdateRequest?.call();
          }
        },
        onLongPress: () {
          if (widget.selectedIds.contains(widget.listModel.id)) {
            widget.selectedIds.remove(widget.listModel.id);
          } else {
            widget.selectedIds.add(widget.listModel.id);
          }
          widget.onUpdateRequest?.call();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.listModel.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: widget.selectedIds.contains(widget.listModel.id)
                    ? Colors.blue.shade800
                    : widget.listModel.color == Colors.white
                        ? Colors.grey
                        : Colors.transparent,
                width: widget.selectedIds.contains(widget.listModel.id) ? 3.0 : 0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        widget.listModel.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  DataManager().settingsModel.showTimeChecked
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            Utils.getFormattedDateTime(widget.listModel.createdAt),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 5, bottom: 10),
                child: Column(
                  children: [
                    for (ListItem item in widget.listModel.items)
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            item.ticked
                                ? Icon(
                                    Icons.check_box_outlined,
                                    color: Colors.grey.shade500,
                                    size: 20,
                                  )
                                : Icon(Icons.check_box_outline_blank, size: 20, color: Colors.grey.shade500),
                            Text(
                              item.name,
                              style: TextStyle(color: Colors.grey.shade600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.listModel.scheduleTime != null && !isTimePassed)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.alarm,
                          size: 20,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Text(
                        Utils.getFormattedDateTime(DateTime(
                          widget.listModel.scheduleTime!.year,
                          widget.listModel.scheduleTime!.month,
                          widget.listModel.scheduleTime!.day,
                          widget.listModel.scheduleTime!.hour,
                          widget.listModel.scheduleTime!.minute,
                        )),
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              DataManager().settingsModel.showLabelsOnHomeScreen
                  ? Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Wrap(
                        children: [
                          for (int i = 0; i < widget.listModel.labels.length; i++)
                            i < 3
                                ? Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                        child: Text(
                                          '  ${widget.listModel.labels[i]}  ',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : i == 4
                                    ? Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                            child: Text(
                                              '  +${widget.listModel.labels.length - 3}  ',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListModelTileGridView extends StatefulWidget {
  final List<String> selectedIds;
  final Function? onUpdateRequest;
  final ListModel listModel;

  const ListModelTileGridView({
    Key? key,
    required this.selectedIds,
    this.onUpdateRequest,
    required this.listModel,
  }) : super(key: key);

  @override
  State<ListModelTileGridView> createState() => _ListModelTileGridViewState();
}

class _ListModelTileGridViewState extends State<ListModelTileGridView> {
  late bool isTimePassed;

  @override
  void initState() {
    if (widget.listModel.scheduleTime != null) {
      isTimePassed = DateTime.now().isAfter(widget.listModel.scheduleTime!);
    } else {
      isTimePassed = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<DataManager>();
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 5,
      padding: const EdgeInsets.all(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (widget.selectedIds.isEmpty) {
            Navigator.of(context).pushNamed(Routes.viewOrEditListModel, arguments: widget.listModel);
          } else {
            if (widget.selectedIds.contains(widget.listModel.id)) {
              widget.selectedIds.remove(widget.listModel.id);
            } else {
              widget.selectedIds.add(widget.listModel.id);
            }
            widget.onUpdateRequest?.call();
          }
        },
        onLongPress: () {
          if (widget.selectedIds.contains(widget.listModel.id)) {
            widget.selectedIds.remove(widget.listModel.id);
          } else {
            widget.selectedIds.add(widget.listModel.id);
          }
          widget.onUpdateRequest?.call();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.listModel.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: widget.selectedIds.contains(widget.listModel.id)
                    ? Colors.blue.shade800
                    : widget.listModel.color == Colors.white
                        ? Colors.grey
                        : Colors.transparent,
                width: widget.selectedIds.contains(widget.listModel.id) ? 3.0 : 0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        widget.listModel.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  DataManager().settingsModel.showTimeChecked
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            Utils.getFormattedDateTime(widget.listModel.createdAt),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Wrap(
                  children: [
                    for (ListItem listItem in widget.listModel.items)
                      Row(
                        children: [
                          listItem.ticked
                              ? Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.grey.shade500,
                                  size: 20,
                                )
                              : Icon(
                                  Icons.check_box_outline_blank,
                                  color: Colors.grey.shade500,
                                  size: 20,
                                ),
                          Text(
                            listItem.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (widget.listModel.scheduleTime != null && !isTimePassed)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.alarm,
                          size: 20,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Text(
                        Utils.getFormattedDateTime(DateTime(
                          widget.listModel.scheduleTime!.year,
                          widget.listModel.scheduleTime!.month,
                          widget.listModel.scheduleTime!.day,
                          widget.listModel.scheduleTime!.hour,
                          widget.listModel.scheduleTime!.minute,
                        )),
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              DataManager().settingsModel.showLabelsOnHomeScreen
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Wrap(
                          children: [
                            for (int i = 0; i < widget.listModel.labels.length; i++)
                              i < 3
                                  ? Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          '  ${widget.listModel.labels[i]}  ',
                                        ),
                                      ),
                                    )
                                  : i == 4
                                      ? Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                              child: Text(
                                                '  +${widget.listModel.labels.length - 3}  ',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
