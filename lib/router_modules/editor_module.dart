import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/screens/editor_page.dart';

class EditorModule extends Module {
  @override
  void routes(r) {
    r.child('/:id', child: (context) => EditorPage(id: r.args.params['id']));
  }
}
