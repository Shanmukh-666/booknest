import 'package:material_ui/material_ui.dart';
import 'app.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = await LocalStorageService.init();
  runApp(BookNestApp(storageService: storageService));
}
