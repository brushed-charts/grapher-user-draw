import 'package:grapher_user_draw/figure.dart';
import 'package:grapher_user_draw/figure_database_interface.dart';

class FigureDatabaseTester implements FigureDatabaseInterface {
  var figures = <Figure>[];
  @override
  List<Figure> load(DateTime? from, DateTime? to) {
    return figures;
  }

  @override
  void save(Figure newFigure, List<Figure> allFigures) {
    figures = allFigures;
  }
}
