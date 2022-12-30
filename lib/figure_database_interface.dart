import 'package:grapher_user_draw/figure.dart';

abstract class FigureDatabaseInterface {
  void save(Figure newFigure);
  void delete(Figure figureToDelete);
  List<Figure> load();
}
