import 'package:grapher_user_draw/figure.dart';

abstract class FigureDatabaseInterface {
  void save(Figure newFigure, List<Figure> allFigures);
  void delete(Figure figureToDelete, List<Figure> allFigures);
  List<Figure> load();
}
