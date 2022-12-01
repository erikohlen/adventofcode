import 'dart:io';
import 'package:path/path.dart' as p;

String readFile(String path) {
  var filePath = p.join(Directory.current.path, 'lib/1/sample.txt');
  File file = File(filePath);
  return file.readAsStringSync();
}

void main(List<String> arguments) {
  print('This is 1 jan.');

  String sample = readFile('lib/1/sample.txt');
  print(sample);

  // Split the string into lines.
  List<String> lines = sample.split('\n');
  lines.forEach((element) {
    print(element);
  });
}
