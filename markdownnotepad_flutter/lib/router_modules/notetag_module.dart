import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/screens/notetag_page.dart';

class NoteTagModule extends Module {
  @override
  void routes(r) {
    r.child('/:id',
        child: (context) => NoteTagPage(noteTagID: r.args.params['id']));
  }
}
