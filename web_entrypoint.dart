import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:afaan_koo_app/main.dart' as app;



void main() {


  setUrlStrategy(
    PathUrlStrategy(),
  );


  app.main();


}