import "package:intl/intl.dart";

//final _hourMinute = DateFormat("h:m");

final _hourMinute = DateFormat.jm();

String dateToHHMM(DateTime d) => _hourMinute.format(d);
