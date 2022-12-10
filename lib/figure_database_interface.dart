import 'package:grapher_user_draw/figure.dart';

abstract class FigureDatabaseInterface {
  void save(Figure newFigure, List<Figure> allFigures);
  List<Figure> load(DateTime? from, DateTime? to);
}
