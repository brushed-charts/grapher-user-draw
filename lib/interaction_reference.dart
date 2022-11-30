import 'package:grapher_user_draw/user_interaction/edition_interaction.dart';
import 'package:grapher_user_draw/user_interaction/user_interaction_interface.dart';

import 'draw_tools/draw_tool_interface.dart';

class InteractionReference {
  DrawToolInterface? tool;
  UserInteractionInterface interface = EditionInteraction();
}
