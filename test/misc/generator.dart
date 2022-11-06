import 'dart:math';

import 'package:grapher_user_draw/core/anchor.dart';
import 'package:grapher_user_draw/core/anchor_2d.dart';
import 'package:grapher_user_draw/core/anchor_group.dart';
import 'package:grapher_user_draw/logic/figure.dart';
import 'package:grapher_user_draw/logic/path.dart';

class GroupRulesTester extends AnchorGroup {
  @override
  final id = Random().nextInt(100);
  GroupRulesTester(int expectedPoints) : super(expectedPoints);
}

AnchorGroup generateGroup(
    {required int expectedPoint,
    required int presentPoint,
    DateTime? xBase,
    Duration? interval}) {
  final group = GroupRulesTester(expectedPoint);
  var currentdatetime = xBase;
  for (var i = 0; i < presentPoint; i++) {
    final anchor = generateAnchor(currentdatetime);
    currentdatetime = currentdatetime?.add(interval ?? const Duration());
    group.add(anchor);
  }
  return group;
}

Anchor2D generateAnchor([DateTime? datetime]) {
  final x = datetime ?? DateTime.now();
  const groupID = 1234;
  final y = Random.secure().nextDouble();
  final anchor = Anchor2D(groupID, x, y);
  return anchor;
}

Path generatePath(int expectedPoints, int presentPoints,
    {String type = 'aTesterType', DateTime? xBase, Duration? interval}) {
  final path = Path(type, expectedPoints);
  final grp = generateGroup(
      expectedPoint: expectedPoints,
      presentPoint: presentPoints,
      xBase: xBase,
      interval: interval);
  path.anchorList.addAll(grp.anchorList.cast<Anchor2D>());
  return path;
}

Figure generateFigure(int expectedPoints, int presentPoints,
    {DateTime? xBase, Duration? interval}) {
  final fig = Figure(expectedPoints);
  final grp = generateGroup(
      expectedPoint: expectedPoints,
      presentPoint: presentPoints,
      xBase: xBase,
      interval: interval);
  fig.anchorList.addAll(grp.anchorList.cast<Anchor2D>());
  return fig;
}

List<Figure> generateFigureList(int figureCount,
    [DateTime? xBase, Duration? interval]) {
  final figures = <Figure>[];
  for (int i = 0; i < figureCount; i++) {
    final grp = generateFigure(4, 4, xBase: xBase, interval: interval);
    figures.add(grp);
  }
  return figures;
}
