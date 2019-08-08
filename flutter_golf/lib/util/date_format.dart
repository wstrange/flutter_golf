import "package:intl/intl.dart";

//final _hourMinute = DateFormat("h:m");

final _hourMinute = DateFormat.jm();

String dateToHHMM(DateTime d) => _hourMinute.format(d.toLocal());

final _ymdFormatter = new DateFormat('yyyyMMdd');

String dateToYearMonthDay(DateTime d) => _ymdFormatter.format(d.toLocal());

final _dateToDay = DateFormat("EEE, MMM d");

String dateToDay(DateTime d) => _dateToDay.format(d.toLocal());

final _dateToTeeTime = DateFormat("EEE, MMM d  hh:mm");

String dateToTeeTime(DateTime d) => _dateToTeeTime.format(d.toLocal());
