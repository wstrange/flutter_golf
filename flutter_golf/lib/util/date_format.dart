import "package:intl/intl.dart";

//final _hourMinute = DateFormat("h:m");

final _hourMinute = DateFormat.jm();

String dateToHHMM(DateTime d) => _hourMinute.format(d);

final _ymdFormatter = new DateFormat('yyyyMMdd');

String dateToYearMonthDay(DateTime d) => _ymdFormatter.format(d);
