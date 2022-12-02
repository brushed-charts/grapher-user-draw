import 'package:flutter/material.dart';
import 'package:grapher/filter/dataStruct/data2D.dart';
import 'package:grapher/kernel/drawEvent.dart';
import 'package:grapher/kernel/drawZone.dart';
import 'package:grapher/kernel/object.dart';
import 'package:grapher/kernel/propagator/single.dart';
import 'package:grapher/utils/range.dart';
import 'package:grapher/view/axis/unit-axis.dart';
import 'package:grapher/view/axis/virtual-axis.dart';
import 'package:grapher/view/view-event.dart';
import 'package:grapher/view/viewable.dart';
import 'package:mocktail/mocktail.dart';

class MockPropagator extends Viewable with SinglePropagator {
  MockPropagator(GraphObject child) {
    this.child = child;
  }

  void emit(dynamic event) {
    propagate(event);
  }
}

class MockViewEvent extends Mock implements ViewEvent {
  @override
  final Canvas canvas;
  @override
  final DrawZone drawZone;
  final UnitAxis unitAxis;
  final VirtualAxis virtualAxis;
  final Iterable<Data2D?> chaineData;
  MockViewEvent(
      {DrawEvent? drawEvent,
      UnitAxis? unitAxis,
      VirtualAxis? virtualAxis,
      Iterable<Data2D?>? chainData})
      : canvas = drawEvent?.canvas ?? MockDrawEvent().canvas,
        drawZone = drawEvent?.drawZone ?? MockDrawEvent().drawZone,
        unitAxis = unitAxis ?? MockUnitAxis(),
        virtualAxis = virtualAxis ?? MockVirtualAxis(),
        chaineData = <Data2D?>[];
}

class MockDrawEvent extends Mock implements DrawEvent {
  @override
  final Canvas canvas;
  @override
  final DrawZone drawZone;
  MockDrawEvent({Canvas? canvas, DrawZone? drawZone})
      : canvas = canvas ?? MockCanvas(),
        drawZone =
            drawZone ?? DrawZone(const Offset(0, 0), const Size(1500, 900));
}

class MockCanvas extends Mock implements Canvas {}

class MockUnitAxis extends Mock implements UnitAxis {
  @override
  late Range pixelRange = Range(0, 1500);
  @override
  late double unitLength = 2;
}

class MockVirtualAxis extends Mock implements VirtualAxis {
  @override
  late Range pixelRange = Range(0, 900);
  @override
  late Range virtualRange = Range(1, 2);
}

void main() {}
