main() {
  var d = DateTime.now();

  print(d.toIso8601String());

  var x = DateTime.parse(d.toIso8601String());

  print(d.compareTo(x));
}
