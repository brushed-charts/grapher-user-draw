import 'package:grapher_user_draw/anchor.dart';
import 'package:grapher_user_draw/example/draw_tool_tester.dart';
import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/figure_database_interface.dart';

class FigureDatabaseTester implements FigureDatabaseInterface {
  final defaultFigure = Figure(DrawToolTester());
  var figures = <Figure>[];

  FigureDatabaseTester() {
    defaultFigure
        .add(Anchor(x: DateTime.utc(2021, 01, 28, 10, 04, 00), y: 1.211065));
    defaultFigure
        .add(Anchor(x: DateTime.utc(2021, 01, 28, 10, 04, 20), y: 1.211061));
    defaultFigure
        .add(Anchor(x: DateTime.utc(2021, 01, 28, 10, 04, 55), y: 1.211059));
    figures.add(defaultFigure);
  }

  @override
  List<Figure> load() {
    return figures;
  }

  @override
  void save(Figure newFigure, List<Figure> allFigures) {
    figures = allFigures;
  }

  @override
  void delete(Figure figureToDelete, List<Figure> allFigures) {
    figures = allFigures;
  }
}
