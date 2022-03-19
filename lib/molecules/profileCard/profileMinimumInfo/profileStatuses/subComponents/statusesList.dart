import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:zwap_design_system/molecules/profileCard/profileMinimumInfo/profileStatuses/subComponents/plusIcon.dart';
import 'package:zwap_design_system/objects/objects.dart';

import 'singleStatus.dart';


class StatusesListWidget extends StatefulWidget {

  final int _kInitialShowCount = 8;

  final List<StatusModel> statuses;

  final Function(StatusModel status) onStatusTap;

  const StatusesListWidget({
    required this.statuses,
    required this.onStatusTap,
    Key? key,
  }) : super(key: key);

  @override
  State<StatusesListWidget> createState() => _StatusesListWidgetState();
}

class _StatusesListWidgetState extends State<StatusesListWidget> {

  late bool _showAll;

  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _showAll = false;
  }

  @override
  Widget build(BuildContext context) {
    final List<StatusModel> _showedStatus =
    widget.statuses.length > widget._kInitialShowCount && !_showAll ? widget.statuses.sublist(0, widget._kInitialShowCount) : widget.statuses;

    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        ..._showedStatus.mapIndexed(
              (i, status) {
            return SingleStatus(
              status: status,
              onStatusTap: widget.onStatusTap,
              changeIndex: (int? newIndex) => setState(() => _hoveredIndex = newIndex),
              currentIndex: i,
              hoveredIndex: _hoveredIndex,
            );
          },
        ).toList(),
        if (widget.statuses.length > widget._kInitialShowCount && !_showAll)
          PlusIcon(
              onTapCallBack: () => setState(() => _showAll = true),
              onHoverCallBack: (bool isHovered) => setState(() => _hoveredIndex = isHovered ? widget.statuses.length : null),
              decorationCheck: _hoveredIndex == widget.statuses.length,
              totalCount: '${widget.statuses.length - widget._kInitialShowCount}'),
      ],
    );
  }
}